//
//  ViewController.swift
//  RainOrShine
//
//  Created by Andy Lim on 1/18/21.
//  Copyright © 2021 Andy Lim. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //self.registerTableViewCells()
    }
    
    func registerTableViewCells()
    {
        /*
        let notificationSettingViewCell = UINib(nibName: "NotificatinSettingViewCell", bundle: nil)
        let weatherSettingViewCell = UINib(nibName: "WeatherSettingViewCell", bundle: nil)
        let locationSettingViewCell = UINib(nibName: "LocationSettingViewCell", bundle: nil)
        self.tableView.register(notificationSettingViewCell, forCellReuseIdentifier: "NotificationSettingViewCell")
        self.tableView.register(weatherSettingViewCell, forCellReuseIdentifier: "WeatherSettingViewCell")
        self.tableView.register(locationSettingViewCell, forCellReuseIdentifier: "LocationSettingViewCell")
 */
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3;
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(indexPath.row == 0)
        {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "notificationSettingViewCell") as? NotificationSettingViewCell
            {
                return cell
            }
        }
        else if(indexPath.row == 1)
        {
            
            if let cell = tableView.dequeueReusableCell(withIdentifier: "weatherSettingViewCell") as? WeatherSettingViewCell
            {
                return cell
            }
        }
        else if(indexPath.row == 2)
        {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "locationSettingViewCell") as? LocationSettingViewCell
            {
                return cell
            }
        }
        
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        if(indexPath.row == 0)
        {
            //perform segue for weather settings
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "NotificationSettingsTableViewController") as! NotificationSettingsTableViewController
            self.navigationController?.pushViewController(newViewController, animated: true)
//            performSegue(withIdentifier: "WeatherSettingsTableViewController", sender: indexPath)
        }
        else if(indexPath.row == 1)
        {
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "WeatherSettingsTableViewController") as! WeatherSettingsTableViewController
            self.navigationController?.pushViewController(newViewController, animated: true)
        }
        else if(indexPath.row == 2)
        {
            //perform segue for location settings.
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "LocationSettingsTableViewController") as! LocationSettingsTableViewController
            self.navigationController?.pushViewController(newViewController, animated: true)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //Load data from user probably using DataController
    }


}

