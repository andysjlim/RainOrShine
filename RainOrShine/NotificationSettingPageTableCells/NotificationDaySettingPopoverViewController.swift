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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
