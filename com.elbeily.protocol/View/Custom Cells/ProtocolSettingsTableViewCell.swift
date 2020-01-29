//
//  ProtocolSettingsTableViewCell.swift
//  com.elbeily.protocol
//
//  Created by Tom el Beily on 17.12.19.
//  Copyright © 2019 Tom el Beily. All rights reserved.
//

import UIKit
import RealmSwift
class ProtocolSettingsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var manageParticipantButton: UIButton!
    @IBOutlet weak var participantPicker: UIPickerView!
    @IBOutlet weak var participantLabel: UILabel!
    @IBOutlet weak var writerButton: UIButton!
    @IBOutlet weak var creatorLabel: UILabel!
    @IBOutlet weak var creationLabel: UILabel!
    @IBOutlet weak var stringPicker: UIPickerView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var distributorLabel: UILabel!
    @IBOutlet weak var distributorPicker: UIPickerView!
    @IBOutlet weak var distributorButton: UIButton!
    
    var settingsAddWriter : AddWriter?
    var proto : Protocol?
    var writerArray : [String]?
    var participantArray : [String]?
    var distributorArray : [String]?
    
    let realm = try! Realm()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        stringPicker.delegate = self
        stringPicker.dataSource = self
        stringPicker.largeContentTitle = "1"
        participantPicker.delegate = self
        participantPicker.dataSource = self
        participantPicker.largeContentTitle = "2"
        distributorPicker.delegate = self
        distributorPicker.dataSource = self
        distributorPicker.largeContentTitle = "3"
        
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func dateValueChanged(_ sender: Any) {
        do {
            try realm.write {
                proto?.date = datePicker.date
            }
        }catch{print(error)}
    }
    
    
    @IBAction func addWritterPressed(_ sender: Any) {
        settingsAddWriter?.addWriter(proto: proto!)
    }
    
    @IBAction func manageParticipantPressed(_ sender: Any) {
        settingsAddWriter?.addParticipant(proto: proto!)
    }
    @IBAction func distributorButtonPressed(_ sender: Any) {
        settingsAddWriter?.addDistributor(proto: proto!)
        
    }
    @IBAction func changeImageHeaderPressed(_ sender: Any) {
        settingsAddWriter?.goToImageHeader(proto: proto!)

    }
}


extension ProtocolSettingsTableViewCell : UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        
//        print(pickerView)
        var rows = 0
        if pickerView.largeContentTitle == "1" {
            if let arr = writerArray {
                rows = arr.count
            }
        }else if pickerView.largeContentTitle == "2" {
            if let arr = participantArray {
                rows = arr.count
            }
        }else if pickerView.largeContentTitle == "3" {
            if let arr = distributorArray {
                rows = arr.count
            }
        }
        
        return rows
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.largeContentTitle == "1" {
            return writerArray![row]
        }else if pickerView.largeContentTitle == "2" {
            return participantArray![row]
        }else if pickerView.largeContentTitle == "3" {
            return distributorArray![row]
        }
        
        return ""
    }
}
