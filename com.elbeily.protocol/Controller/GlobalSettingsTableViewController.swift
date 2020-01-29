//
//  GlobalSettingsTableViewController.swift
//  com.elbeily.protocol
//
//  Created by Tom el Beily on 26.12.19.
//  Copyright © 2019 Tom el Beily. All rights reserved.
//

import UIKit

class GlobalSettingsTableViewController: MenuController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "ButtonCell", bundle: nil), forCellReuseIdentifier: "buttonCell")
        tableView.register(UINib(nibName: "SwitchTableViewCell", bundle: nil), forCellReuseIdentifier: "switchCell")
        tableView.register(UINib(nibName: "LabelTextBoxCell", bundle: nil), forCellReuseIdentifier:     "labelTextboxCell")
        
        tableView.separatorStyle = .none
        
    }
    
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return indices.count
    }
    
    
    
    let indices = ["headerChange" : 5,
                   "showCostObjectLabel" : 0 ,
                   "showProjektTitleLabel" : 1 ,
                   "showTopicNameLabel" : 2 ,
                   "showCompanyNameLabel" : 3 ,
                   "showContactData" :  4,
                   "contactAddressCountryLabel" : 6 ,
                   "contactAddressZipcodeLabel" :  8,
                   "contactAddressStateLabel" :  7,
                   "contactAddressTownLabel" :  9,
                   "contactAddressStreetLabel" :  10,
                   "companyContactTeleLabel" :  11,
                   "companyContactMailLabel" :  12,
    ]
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let switchCell = tableView.dequeueReusableCell(withIdentifier: "switchCell", for: indexPath) as! SwitchTableViewCell
        
        let tbCell = tableView.dequeueReusableCell(withIdentifier: "labelTextboxCell", for: indexPath) as! LabelTextBoxCell
        
        
        let index = indexPath.row
        tbCell.index = index
        tbCell.selectionStyle = .none
        tbCell.proto = self
        
        if indices["headerChange"] == index {
            let cell = tableView.dequeueReusableCell(withIdentifier: "buttonCell") as! ButtonCell
            cell.button.setTitle(localization.changeHeaderImage, for: .normal)
            cell.buttonPressedProtocol = self
            cell.selectionStyle = .none
            return cell
        }else if indices["showCostObjectLabel"] == index {
            switchCell.label.text = localization.showCostObjectLabel
            switchCell.switch.isOn = globalSettings?.showCostObject ?? true
        }else if indices["showProjektTitleLabel"] == index {
            switchCell.label.text = localization.showProjektTitleLabel
            switchCell.switch.isOn = globalSettings?.showProjektTitle ?? true
        }else if indices["showTopicNameLabel"] == index {
            switchCell.label.text = localization.showTopicNameLabel
            switchCell.switch.isOn = globalSettings?.showTopicName ?? true
        }else if indices["showCompanyNameLabel"] == index {
            switchCell.label.text = localization.showCompanyNameLabel
            switchCell.switch.isOn = globalSettings?.showCompanyName ?? true
        }else if indices["showContactData"] == index {
            switchCell.label.text = localization.showContactAddressLabel
            switchCell.switch.isOn = globalSettings?.showContact ?? true
        }else if indices["contactAddressCountryLabel"] == index {
            tbCell.label.text = localization.contactAddressCountryLabel
            tbCell.textField.text = globalSettings!.contactAddressCountry
            return tbCell
        }else if indices["contactAddressZipcodeLabel"] == index {
            tbCell.label.text = localization.contactAddressZipcodeLabel
            tbCell.textField.text = globalSettings!.contactAddressZipcode
            return tbCell
        }else if indices["contactAddressStateLabel"] == index {
            tbCell.label.text = localization.contactAddressStateLabel
            tbCell.textField.text = globalSettings!.contactAddressState
            return tbCell
        }else if indices["contactAddressTownLabel"] == index {
            tbCell.label.text = localization.contactAddressTownLabel
            tbCell.textField.text = globalSettings!.contactAddressTown
            return tbCell
        }else if indices["contactAddressStreetLabel"] == index {
            tbCell.label.text = localization.contactAddressStreetLabel
            tbCell.textField.text = globalSettings!.contactAddressStreet
            return tbCell
        }else if indices["companyContactTeleLabel"] == index {
            tbCell.label.text = localization.companyContactTeleLabel
            tbCell.textField.text = globalSettings!.companyContactTele
            return tbCell
        }else if indices["companyContactMailLabel"] == index {
            tbCell.label.text = localization.companyContactMailLabel
            tbCell.textField.text = globalSettings!.companyContactMail
            return tbCell
        }
        
        switchCell.selectionStyle = .none
        switchCell.index = index
        switchCell.switchEvent = self
        switchCell.label.numberOfLines = 0
        
        return switchCell
    }
}

extension GlobalSettingsTableViewController : ButtonEvent {
    func updatedTextField(index: Int, text: String) {
        do {
            try realm.write {
                if indices["contactAddressCountryLabel"] == index {
                    globalSettings!.contactAddressCountry = text
                }else if indices["contactAddressZipcodeLabel"] == index {
                    globalSettings!.contactAddressZipcode = text
                }else if indices["contactAddressStateLabel"] == index {
                    globalSettings!.contactAddressState = text
                }else if indices["contactAddressTownLabel"] == index {
                    globalSettings!.contactAddressTown = text
                }else if indices["contactAddressStreetLabel"] == index {
                    globalSettings!.contactAddressStreet = text
                }else if indices["companyContactTeleLabel"] == index {
                    globalSettings!.companyContactTele = text
                }else if indices["companyContactMailLabel"] == index {
                    globalSettings!.companyContactMail = text
                }
            }
        }catch{print(error)}
        
    }
    
    func pressed(){
        performSegue(withIdentifier: "goToHeaderImage", sender: self)
    }
}

protocol SwitchPressed {
    func pressed(index: Int, state : Bool)
}

extension GlobalSettingsTableViewController : SwitchPressed {
    func pressed(index: Int, state: Bool) {
        do {
            try realm.write {
                if let settings = super.globalSettings {
                    if indices["showCostObjectLabel"] == index {
                        settings.showCostObject = state
                    }else if indices["showProjektTitleLabel"] == index {
                        settings.showProjektTitle = state
                    }else if indices["showTopicNameLabel"] == index {
                        settings.showTopicName = state
                    }else if indices["showCompanyNameLabel"] == index {
                        settings.showCompanyName = state
                    }else if indices["showContactData"] == index {
                        settings.showContact = state
                    }
                }
            }
        }catch{print(error)}
        
        
    }
}
