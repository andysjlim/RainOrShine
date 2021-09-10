//
//  AppDelegate.swift
//  RainOrShine
//
//  Created by Andy Lim on 1/18/21.
//  Copyright © 2021 Andy Lim. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications
import BackgroundTasks

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, CLLocationManagerDelegate {
    
    let notificationCenter = UNUserNotificationCenter.current()
    var locationManager : CLLocationManager!
    var currentLocation: CLLocation?
    var weather : OneCall?
    let onlyOneIdentifier: String = "com.example.apicall"
    
    func requestAuthForLocalNotifications() {
        notificationCenter.delegate = self
        let options : UNAuthorizationOptions = [.alert, .sound, .badge]
        notificationCenter.requestAuthorization(options: options) { (didAllow, error) in
            if !didAllow {
                print("User has declined notification")
            }
            
        }
    }
    
    override init() {
        super.init()
        BGTaskScheduler.shared.register(forTaskWithIdentifier: onlyOneIdentifier,
                                                using: nil) { task in
                    self.handleAppRefresh(task: task as! BGAppRefreshTask)
            print("Will you call this one day?")
                }
        print("App: BackgroundTask registered.")
        self.requestAuthForLocalNotifications()
        self.getLocation()
        print("What is this gets called?")
    }
    
    func getLocation() {
        if (CLLocationManager.locationServicesEnabled()) {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
            locationManager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        debugPrint(error.localizedDescription)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            self.currentLocation = location
            
            let latitude: Double = self.currentLocation!.coordinate.latitude
            let longitude: Double = self.currentLocation!.coordinate.longitude
            
            WeatherNetworkManager.shared.setLatitude(latitude)
            WeatherNetworkManager.shared.setLongitude(longitude)
            
            WeatherNetworkManager.shared.fetchOneCallLocationWeather(completion: { (currentWeather) in
                self.weather = currentWeather
                
                self.weather?.sortHourlyArray()
                print(currentWeather)
                print("oh wow!")
                self.scheduleLocalNotification()
            })
            
            /*
            let geocoder = CLGeocoder()
            geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
                if let error = error {
                    debugPrint(error.localizedDescription)
                }
                if let placemarks = placemarks {
                    if placemarks.count > 0 {
                        let placemark = placemarks[0]
                        if let city = placemark.locality {
                            self.city = city
                        }
                    }
                }
                
            }
            */
        }
    }
    
    func applicationDidFinishLaunching(_ application: UIApplication) {
        BGTaskScheduler.shared.register(forTaskWithIdentifier: onlyOneIdentifier, using: nil) { task in
            debugPrint("REGISTERING TASK!")
            self.handleAppRefresh(task: task as! BGAppRefreshTask)
        }
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        self.requestAuthForLocalNotifications()
        self.getLocation()
        
        print("Wow")
        
//        BGTaskScheduler.shared.register(forTaskWithIdentifier: onlyOneIdentifier, using: nil) { task in
//            debugPrint("REGISTERING TASK!")
//            self.handleAppRefresh(task: task as! BGAppRefreshTask)
//        }
        
        print("wow again!")
        
        return true
    }
    
    func scheduleAppRefresh() {
        let request = BGAppRefreshTaskRequest(identifier: onlyOneIdentifier)
        request.earliestBeginDate = Date(timeIntervalSinceNow: 60)
        
        do {
            try BGTaskScheduler.shared.submit(request)
            print("Submitted!")
        } catch {
            print("Could not schedule app refresh: \(error)")
        }
    }
    
    func handleAppRefresh(task: BGAppRefreshTask) {
        scheduleAppRefresh()
        
        let refreshQueue = OperationQueue()
        refreshQueue.qualityOfService = .background
        refreshQueue.maxConcurrentOperationCount = 1
        
        let refreshOperation = BlockOperation {
            
            OperationQueue.main.addOperation {
                self.scheduleLocalNotification()
            }
        }
        
        refreshOperation.completionBlock = { task.setTaskCompleted(success: true)}
        
        task.expirationHandler = {
            refreshQueue.cancelAllOperations()
            task.setTaskCompleted(success: true)
        }
    }
    
    func scheduleLocalNotification() {
        var scheduledDayCD : ScheduledDaysCD?
        
        if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
        {
            if let savedSchedulesFromCoreData = try? context.fetch(ScheduledDaysCD.fetchRequest()){
                if let scheduledDays = savedSchedulesFromCoreData as? [ScheduledDaysCD] {
                    if scheduledDays.count != 0 {
                        scheduledDayCD = scheduledDays[0]
                    }
                }
            }
        }
        
        var goThrough = false
        
        var day = ""
        day = Date.dayNameOfWeek()!
        
        print(day)
        
        if let scheduledDayCD = scheduledDayCD as ScheduledDaysCD? {
            switch day {
            case "Monday":
                goThrough = scheduledDayCD.mondayEnabled
            case "Tuesday":
                goThrough = scheduledDayCD.tuesdayEnabled
            case "Wednesday":
                goThrough = scheduledDayCD.wednesdayEnabled
            case "Thursday":
                goThrough = scheduledDayCD.thursdayEnabled
            case "Friday":
                goThrough = scheduledDayCD.fridayEnabled
            case "Saturday":
                goThrough = scheduledDayCD.saturdayEnabled
            case "Sunday":
                goThrough = scheduledDayCD.sundayEnabled
            default:
                goThrough = false
            }
        }
        
        if !goThrough { return }
        
        WeatherNetworkManager.shared.fetchOneCallLocationWeather(completion: { (currentWeather) in
            self.weather = currentWeather
            
            self.weather?.sortHourlyArray()
        })
        
        
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            if settings.authorizationStatus == UNAuthorizationStatus.authorized {
                let content = UNMutableNotificationContent()
                if((self.weather?.hourly[0].weather[0].id)! < 600)
                {
                    content.title = "It will rain!"
                }
                else
                {
                    content.title = "It will not rain!"
                }
                
                content.body = (self.weather?.hourly[0].weather[0].description)!
                content.sound = UNNotificationSound.default
                
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 20, repeats: false)
                
                let request = UNNotificationRequest(identifier: day, content: content, trigger: trigger)
                
                let notificationCenter = UNUserNotificationCenter.current()
                
                notificationCenter.add(request) { (error) in
                    if error != nil {
                        print("Error in notification")
                    }
                }
            }
            else {
                print("User hasn't allowed notificatino settings")
            }
        }
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "RainOrShine")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

