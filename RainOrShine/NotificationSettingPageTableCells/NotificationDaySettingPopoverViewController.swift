//
//  NotificationDaySettingPopoverViewController.swift
//  RainOrShine
//
//  Created by Andy Lim on 8/14/21.
//  Copyright © 2021 Andy Lim. All rights reserved.
//

import UIKit

class NotificationDaySettingPopoverViewController: UIViewController {

    @IBOutlet var monday: CheckBox!
    @IBOutlet var tuesday: CheckBox!
    @IBOutlet var wednesday: CheckBox!
    @IBOutlet var thursday: CheckBox!
    @IBOutlet var friday: CheckBox!
    @IBOutlet var saturday: CheckBox!
    @IBOutlet var sunday: CheckBox!
    
    var scheduledDayCD : ScheduledDaysCD?
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
        
        if let nonNullScheduledDayCD = scheduledDayCD as ScheduledDaysCD? {
            monday.isChecked = nonNullScheduledDayCD.mondayEnabled
            tuesday.isChecked = nonNullScheduledDayCD.tuesdayEnabled
            wednesday.isChecked = nonNullScheduledDayCD.wednesdayEnabled
            thursday.isChecked = nonNullScheduledDayCD.thursdayEnabled
            friday.isChecked = nonNullScheduledDayCD.fridayEnabled
            saturday.isChecked = nonNullScheduledDayCD.saturdayEnabled
            sunday.isChecked = nonNullScheduledDayCD.sundayEnabled
        }
        else {
            monday.isChecked = false
            tuesday.isChecked = false
            wednesday.isChecked = false
            thursday.isChecked = false
            friday.isChecked = false
            saturday.isChecked = false
            sunday.isChecked = false
        }
        
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func applyClicked(_ sender: UIButton) {
        if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
        {
            if let savedSchedulesFromCoreData = try? context.fetch(ScheduledDaysCD.fetchRequest()){
                if let scheduledDays = savedSchedulesFromCoreData as? [ScheduledDaysCD] {
                    let scheduledDaysCD : ScheduledDaysCD
                    if scheduledDays.count != 0 {
                        scheduledDaysCD = scheduledDays[0]
                    }
                    else {
                        scheduledDaysCD = ScheduledDaysCD(context: context)
                    }
                    
                    scheduledDaysCD.setValue(monday.isChecked, forKey: "mondayEnabled")
                    scheduledDaysCD.setValue(tuesday.isChecked, forKey: "tuesdayEnabled")
                    scheduledDaysCD.setValue(wednesday.isChecked, forKey: "wednesdayEnabled")
                    scheduledDaysCD.setValue(thursday.isChecked, forKey: "thursdayEnabled")
                    scheduledDaysCD.setValue(friday.isChecked, forKey: "fridayEnabled")
                    scheduledDaysCD.setValue(saturday.isChecked, forKey: "saturdayEnabled")
                    scheduledDaysCD.setValue(sunday.isChecked, forKey: "sundayEnabled")
                    
                    (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
                }
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
