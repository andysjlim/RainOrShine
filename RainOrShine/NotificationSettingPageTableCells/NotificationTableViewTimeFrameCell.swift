//
//  NotificationTableViewTimeFrameCell.swift
//  RainOrShine
//
//  Created by Andy Lim on 8/4/21.
//  Copyright © 2021 Andy Lim. All rights reserved.
//

import UIKit

class NotificationTableViewTimeFrameCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.textLabel?.text = "Time Frame Setting"
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
