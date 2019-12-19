//
//  StringPickerCell.swift
//  com.elbeily.protocol
//
//  Created by Tom el Beily on 10.12.19.
//  Copyright © 2019 Tom el Beily. All rights reserved.
//

import UIKit

class StringPickerCell: UITableViewCell {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var preview: UILabel!
    @IBOutlet weak var labelcontainer: UIView!
    @IBOutlet weak var pickercontainer: UIView!
    @IBOutlet weak var picker: UIPickerView!
    
    var origHeight : CGFloat = 0
    var origPrevHeight : CGFloat = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        origHeight = 40//pickercontainer.frame.height
        origPrevHeight = 40//pickercontainer.frame.height
        hidePicker()
        let tap = UITapGestureRecognizer(target: self, action: Selector(("hidePicker")))
        preview.addGestureRecognizer(tap)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func showPicker(){
        pickercontainer.frame.size.height = origHeight
        label.frame.size.height = 0
        picker.isHidden = false
        preview.isHidden = true
    }
    
    func hidePicker() {
        pickercontainer.frame.size.height = 0
        label.frame.size.height = origPrevHeight
        picker.isHidden = true
        preview.isHidden = false
    }
    
}
