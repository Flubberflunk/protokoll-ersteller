//
//  ButtonCell.swift
//  com.elbeily.protocol
//
//  Created by Tom el Beily on 10.12.19.
//  Copyright © 2019 Tom el Beily. All rights reserved.
//

import UIKit

class ButtonCell: UITableViewCell {
    @IBOutlet weak var buttonBg: UIView!
    
    @IBOutlet weak var button: UIButton!
    
    var buttonPressedProtocol : ButtonEvent?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func buttonPressed(_ sender: Any) {
        buttonPressedProtocol?.pressed()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
