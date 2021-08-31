//
//  NotificationTableViewTimeCell.swift
//  RainOrShine
//
//  Created by Andy Lim on 8/4/21.
//  Copyright © 2021 Andy Lim. All rights reserved.
//

import UIKit

class NotificationTableViewTimeCell: UITableViewCell {
    @IBOutlet weak var timePicker: UIDatePicker!
    
    var scheduledTimeCD : ScheduledTimeCD?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
        {
            if let savedSchedulesFromCoreData = try? context.fetch(ScheduledTimeCD.fetchRequest()){
                if let scheduledTimes = savedSchedulesFromCoreData as? [ScheduledTimeCD] {
                    if scheduledTimes.count != 0 {
                        scheduledTimeCD = scheduledTimes[0]
                    }
                }
            }
        }
        
        if let nonNullScheduledTimeCD = scheduledTimeCD as ScheduledTimeCD? {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm"
            
            let date = dateFormatter.date(from: ""+String(nonNullScheduledTimeCD.hour)+":"+String(nonNullScheduledTimeCD.minutes))
            
            timePicker.date = date!
        }
    }
    
    @IBAction func timeValueFinishedChanging(_ sender: UIDatePicker) {
        print(sender.date)
        let component = Calendar.current.dateComponents([.hour, .minute], from: sender.date)
        print(component.hour!)
        print(component.minute!)
        print("User finished changing time")
        
        if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
        {
            if let savedSchedulesFromCoreData = try? context.fetch(ScheduledTimeCD.fetchRequest()){
                if let scheduledTimes = savedSchedulesFromCoreData as? [ScheduledTimeCD] {
                    let scheduledTimeCD : ScheduledTimeCD
                    if scheduledTimes.count != 0 {
                        scheduledTimeCD = scheduledTimes[0]
                    }
                    else {
                        scheduledTimeCD = ScheduledTimeCD(context: context)
                    }
                    
                    scheduledTimeCD.setValue(Int16(component.hour!), forKey: "hour")
                    scheduledTimeCD.setValue(Int16(component.minute!), forKey: "minutes")
                    
                    (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
                }
            }
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {

    }

}
