//
//  SelectParticipantCell.swift
//  com.elbeily.protocol
//
//  Created by Tom el Beily on 14.12.19.
//  Copyright © 2019 Tom el Beily. All rights reserved.
//

import UIKit

class SelectParticipantCell: UITableViewCell {
    
    @IBOutlet weak var checkedImg: UIImageView!
    
    @IBOutlet weak var editImage: UIImageView!
    @IBOutlet weak var company: UILabel!
    @IBOutlet weak var lastname: UILabel!
    @IBOutlet weak var firstname: UILabel!
    var index = 0
    var selectParticipantDelegate : SelectParticipantTableViewController?
    
    @IBOutlet weak var sign: UILabel!
    var participantSelected = false
    override func awakeFromNib() {
        super.awakeFromNib()
        let tap = UITapGestureRecognizer(target: self, action: #selector(editPressed))
        editImage.addGestureRecognizer(tap)
        editImage.isUserInteractionEnabled = true    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @objc func editPressed(){
        selectParticipantDelegate?.editParticipant(index : index)
    }
    
}
