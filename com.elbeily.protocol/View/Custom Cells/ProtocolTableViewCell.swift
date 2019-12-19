//
//  ProtocolTableViewCell.swift
//  com.elbeily.protocol
//
//  Created by Tom el Beily on 16.12.19.
//  Copyright © 2019 Tom el Beily. All rights reserved.
//

import UIKit

class ProtocolTableViewCell: UITableViewCell {

    @IBOutlet weak var settingsImage: UIImageView!
    @IBOutlet weak var creatorLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var objectLabel: UILabel!
    @IBOutlet weak var shareImage: UIImageView!
    
    var homeControllerDelegate : HomeTableViewController?
    var index : Int?
    override func awakeFromNib() {
        super.awakeFromNib()
            
        let tap = UITapGestureRecognizer(target: self, action: #selector(settingsPressed))
        settingsImage.addGestureRecognizer(tap)
        settingsImage.isUserInteractionEnabled = true
        
        
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(sharePressed))
        shareImage.addGestureRecognizer(tap2)
        shareImage.isUserInteractionEnabled = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @objc func settingsPressed() {
        print("settings pressed")
        homeControllerDelegate?.segueIndex = index
        homeControllerDelegate?.performSegue(withIdentifier: "goToPanelSettings", sender: homeControllerDelegate.self)
    }
    
    @objc func sharePressed(){
        homeControllerDelegate?.segueIndex = index
        homeControllerDelegate?.performSegue(withIdentifier: "goToPDFPreview", sender: homeControllerDelegate.self)
    }
    
}
