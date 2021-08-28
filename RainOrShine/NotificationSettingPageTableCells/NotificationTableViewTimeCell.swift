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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func timeValueChanged(_ sender: UIDatePicker) {
        print(sender.date)
        let component = Calendar.current.dateComponents([.hour, .minute], from: sender.date)
        print(component.hour!)
        print(component.minute!)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {

    }

}
