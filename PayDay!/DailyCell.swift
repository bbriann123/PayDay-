//
//  DailyCell.swift
//  PayDay!
//
//  Created by Brian van den Heuvel on 9/22/15.
//  Copyright © 2015 Brian van den Heuvel. All rights reserved.
//

import UIKit

class DailyCell: UITableViewCell {

    @IBOutlet weak var day: UILabel!
    @IBOutlet weak var fromTime: UILabel!
    @IBOutlet weak var toTime: UILabel!
    @IBOutlet weak var totalTime: UILabel!
    @IBOutlet weak var datum: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
