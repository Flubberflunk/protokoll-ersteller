//
//  SwitchTableViewCell.swift
//  com.elbeily.protocol
//
//  Created by Tom el Beily on 26.12.19.
//  Copyright © 2019 Tom el Beily. All rights reserved.
//

import UIKit

class SwitchTableViewCell: UITableViewCell {

    var index = 0
    var switchEvent : SwitchPressed?

    @IBOutlet weak var `switch`: UISwitch!
    @IBOutlet weak var label: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func switchPressed(_ sender: Any) {
        switchEvent?.pressed(index: index, state: self.switch.isOn)
    }
    
}
