//
//  HeaderImageTableViewCell.swift
//  com.elbeily.protocol
//
//  Created by Tom el Beily on 19.12.19.
//  Copyright © 2019 Tom el Beily. All rights reserved.
//

import UIKit

class HeaderImageTableViewCell: UITableViewCell {

    @IBOutlet weak var imageButton: UIButton!
    @IBOutlet weak var selectedImg: UIImageView!
    
    var delegate : HeaderImageChangeTableViewController?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func imageButtonPressed(_ sender: Any) {
        delegate?.showImagePicker()
    }
    @IBAction func setDefSwitchSwitched(_ sender: Any) {
    }
    
}
