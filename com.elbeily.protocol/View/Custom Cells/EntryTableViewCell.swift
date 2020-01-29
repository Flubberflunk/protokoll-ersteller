//
//  EntryTableViewCell.swift
//  com.elbeily.protocol
//
//  Created by Tom el Beily on 13.12.19.
//  Copyright © 2019 Tom el Beily. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class EntryTableViewCell: UITableViewCell {

    
    let realm = try! Realm()
    var entryControllerDelegate : EntryController?
    var protocolAddExecutee : AddExecutee?
    @IBOutlet weak var addExecutee: UIButton!
    @IBOutlet weak var executees: UIPickerView!
    @IBOutlet weak var executeeLabel: UILabel!
    @IBOutlet weak var executeDate: UIDatePicker!
    @IBOutlet weak var executeDatelabel: UILabel!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var nrLabel: UILabel!
    @IBOutlet weak var nrTextField: UITextField!
    var localization : Localization?
    var executeeArr : [String]?
    var entry : Entry?
    var initialNumber : Double?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        executees.delegate = self
        executees.dataSource = self
        contentTextView.delegate = self
    }
    
    func addStatusTappObserver(){
        if let entry = self.entry {
            let tap = UITapGestureRecognizer(target: self, action: #selector(statusTapped))
            statusLabel.isUserInteractionEnabled = true
            statusLabel.addGestureRecognizer(tap)
        }
    }

    @objc func statusTapped(){
        var status = Status.new
        var nextStatus = Status.working
        
        if let setStatus = entry?.status {
            status = setStatus
        }
        
        switch status {
           
            case Status.working:
                    nextStatus = Status.done
                break
            case Status.done:
                    nextStatus = Status.new
                break
            default:
                break
            
        }
        
        do{
            try realm.write{
                entry?.status = nextStatus
            }
            designStatus(status: nextStatus)
        }catch{
            print(error)
        }
        
        
    }
    
    func designStatus(status: String) {
        var label = ""
        var color = UIColor.flatGreen()
        
        switch status {
            case Status.new:
                label = localization!.new
                color = UIColor.flatRed()
            break
            case Status.working:
                    label = localization!.working
                    color = UIColor.flatOrange()
                break
            case Status.done:
                    label = localization!.done
                   color = UIColor.flatGreen()
                break
            default:
                break
            
        }
        
        statusLabel.text = label
        statusLabel.backgroundColor = color
    }
    
    @IBAction func dateValueChanged(_ sender: Any) {
        if let entry = self.entry {
            let date = executeDate.date
            do {
                try realm.write{
                    entry.dateToExecute = date
                }
            }catch{
                print(error)
            }
        }
    }
    @IBAction func executeDateChanged(_ sender: Any) {
        
    }
    
    @IBAction func nrChanged(_ sender: Any) {
        
        if let entry = self.entry {
            let nr = nrTextField!.text!
            do {
                if let number = Double(nr) {
                    try realm.write{
                        entry.number = number
                        entryControllerDelegate?.updateAllNumber()
                    }
                }
            }catch{
                print(error)
            }
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func addExecuteePressed(_ sender: Any) {
        protocolAddExecutee?.addExecutee(entry: entry!)
    }
    
}


extension EntryTableViewCell : UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        var rows = 0
        if let arr = executeeArr {
            rows = arr.count
        }
        return rows
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return executeeArr![row]
    }
}


extension EntryTableViewCell : UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if let entry = self.entry {
            do {
                try realm.write {
                    entry.content = textView.text
                }
            }catch{
                print(error)
                
            }
        }
    }
}
