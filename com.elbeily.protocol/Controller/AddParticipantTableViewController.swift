//
//  AddParticipantTableViewController.swift
//  com.elbeily.protocol
//
//  Created by Tom el Beily on 10.12.19.
//  Copyright © 2019 Tom el Beily. All rights reserved.
//

import UIKit
import StatusAlert

class AddParticipantTableViewController: MenuController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "LabelTextBoxCell", bundle: nil), forCellReuseIdentifier:     "labelTextboxCell")
        tableView.register(UINib(nibName: "ButtonCell", bundle: nil), forCellReuseIdentifier: "buttonCell")
        tableView.register(UINib(nibName: "StringPickerCell", bundle: nil), forCellReuseIdentifier: "stringPickerCell")
        tableView.separatorStyle = .none
    }
    
    var calledFromSelectPartcipant = false
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ParticipantRows.rows.count + 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let index = indexPath.row
        
        if (index < ParticipantRows.rows.count) {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "labelTextboxCell") as! LabelTextBoxCell
            cell.label .text = ParticipantRows.rows[index]
            cell.proto = self
            cell.index = index
            if(index == ParticipantRows.isCompany) {
                cell.suggestions = getCompanyList()
            }
            return cell
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "buttonCell") as! ButtonCell
            cell.button.setTitle(localization.save, for: .normal)
            cell.buttonPressedProtocol = self
            return cell
        }
    }
}

extension AddParticipantTableViewController : ButtonEvent {
    func pressed(){
        
        let allRequired = 1
        var requiredCnt = 0
        let participant = Participant()
        var validMailAddress = false
        participant.lastName = "dif"

        if let companyName = ParticipantRows.newParticipantValues[localization.company] {
            var company = Company()
            company.name = companyName.trimmingCharacters(in: .whitespaces)
            company = addCompany(company: company)
            participant.company = company
        }
        if let salutation = ParticipantRows.newParticipantValues[localization.salutation] {
            participant.salutation = salutation.trimmingCharacters(in: .whitespaces)
        }
        if let firstname = ParticipantRows.newParticipantValues[localization.firstname] {
            participant.firstName = firstname.trimmingCharacters(in: .whitespaces)
        }
        if let lastname = ParticipantRows.newParticipantValues[localization.lastName] {
            participant.lastName = lastname.trimmingCharacters(in: .whitespaces)
        }
        if let mail = ParticipantRows.newParticipantValues[localization.mail] {
            participant.mail = mail.trimmingCharacters(in: .whitespaces)
            validMailAddress = validateEmail(enteredEmail: participant.mail)
            requiredCnt += 1
        }
        if let sign = ParticipantRows.newParticipantValues[localization.sign] {
            participant.sign = sign.trimmingCharacters(in: .whitespaces)
        }
        
        if requiredCnt >= allRequired {
            if participantIsUnique(participant: participant){
                addParticipant(participant: participant)
                let statusAlert = StatusAlert()
                statusAlert.title = "👍🏻"
                statusAlert.appearance.tintColor = UIColor.flatWhite()
                statusAlert.message = localization.addedParticipant
                statusAlert.canBePickedOrDismissed = true
                statusAlert.showInKeyWindow()
                if calledFromSelectPartcipant {
                    dismiss(animated: true, completion: nil)
                }
                tableView.reloadData()
            }else {
                let statusAlert = StatusAlert()
                statusAlert.title = "❌"
                statusAlert.appearance.tintColor = UIColor.flatWhite()
                statusAlert.message = localization.errMailMustBeUnique
                statusAlert.canBePickedOrDismissed = true
                statusAlert.showInKeyWindow()
            }
            
        } else if(!validMailAddress) {
            let statusAlert = StatusAlert()
            statusAlert.title = "❌"
            statusAlert.appearance.tintColor = UIColor.flatWhite()
            statusAlert.message = localization.pleaseEnterValidMailAddress
            statusAlert.canBePickedOrDismissed = true
            statusAlert.showInKeyWindow()
        }
        else {
            let statusAlert = StatusAlert()
            statusAlert.title = "❌"
            statusAlert.appearance.tintColor = UIColor.flatWhite()
            statusAlert.message = localization.errNotAllRequiredParticipantFieldsWereFilled
            statusAlert.canBePickedOrDismissed = true
            statusAlert.showInKeyWindow()
        }
    }
    
    func updatedTextField(index: Int, text: String) {
        ParticipantRows.newParticipantValues[ParticipantRows.rows[index]!] = text
    }
}

protocol ButtonEvent {
    func pressed()
    func updatedTextField(index:Int,text:String)
}
