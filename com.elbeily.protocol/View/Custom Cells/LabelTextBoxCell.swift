//
//  LabelTextBoxCell.swift
//  com.elbeily.protocol
//
//  Created by Tom el Beily on 10.12.19.
//  Copyright © 2019 Tom el Beily. All rights reserved.
//

import UIKit

class LabelTextBoxCell: UITableViewCell {
    
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var label: UILabel!
    
    var index : Int?
    
    var suggestions : [String]?
    var proto : ButtonEvent?
    var settingsButtonEvent : ProtoSettingsButtonEvent?
    override func awakeFromNib() {
        super.awakeFromNib()
        textField.delegate = self
    }
    
    @IBAction func editingChanged(_ sender: Any) {
        proto?.updatedTextField(index: index ?? 0,text: textField.text ?? "")
        settingsButtonEvent?.updatedTextField(index: index ?? 0,text: textField.text ?? "")
    }
    @IBAction func valueChanged(_ sender: Any) {
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}

extension LabelTextBoxCell : UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let suggestions = self.suggestions {
            return !autoCompleteText( in : textField, using: string, suggestions: suggestions)
        }else {
            return true
        }
    }
     

    
    func autoCompleteText( in textField: UITextField, using string: String, suggestions: [String]) -> Bool {
        if !string.isEmpty,
            let selectedTextRange = textField.selectedTextRange,
            selectedTextRange.end == textField.endOfDocument,
            let prefixRange = textField.textRange(from: textField.beginningOfDocument, to: selectedTextRange.start),
            let text = textField.text( in : prefixRange) {
            let prefix = text + string
            let matches = suggestions.filter {
                $0.hasPrefix(prefix)
            }
            if (matches.count > 0) {
                textField.text = matches[0]
                if let start = textField.position(from: textField.beginningOfDocument, offset: prefix.count) {
                    textField.selectedTextRange = textField.textRange(from: start, to: textField.endOfDocument)
                    return true
                }
            }
        }
        return false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
