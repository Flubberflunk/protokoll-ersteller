//
//  SelectParticipantTableViewController.swift
//  com.elbeily.protocol
//
//  Created by Tom el Beily on 14.12.19.
//  Copyright © 2019 Tom el Beily. All rights reserved.
//

import UIKit
import RealmSwift

class SelectParticipantTableViewController: MenuController {
    
    var currentEntry : Entry?
    var cameFromEntry = false
    var currentProtocol : Protocol?
    var cameFromProtocolSettings = false
    var cameFromProtocolSettingsParticipant = false
    var cameFromProtocolSettingsDistributor = false
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "SelectParticipantCell", bundle: nil), forCellReuseIdentifier: "selectParticipantCell")
        tableView.register(UINib(nibName: "AddButtonCell", bundle: nil), forCellReuseIdentifier: "addButtonCell")
        tableView.register(UINib(nibName: "ButtonCell", bundle: nil), forCellReuseIdentifier: "buttonCell")

    }
    
    // MARK: - Table view data source
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sortedParticipants = getParticipants()
        return sortedParticipants!.count + 2
    }
    
    var sortedParticipants : Results<Participant>?
    func getParticipants() -> Results<Participant> {
        let participants = realm.objects(Participant.self)
        let sortedParticipants = participants.sorted(byKeyPath: "lastAdded", ascending: false)
        return sortedParticipants
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print(indexPath.row , sortedParticipants!.count)
        if (indexPath.row == 0 ) {
            performSegue(withIdentifier: "goToAddParticipant", sender: self)
        }else if indexPath.row <= sortedParticipants!.count  {
            let participant = sortedParticipants![indexPath.row - 1]
            var index = -1
            
            if cameFromEntry {
                index = entryContainsParticipant(entry:currentEntry,participant:participant)
            }else if cameFromProtocolSettings {
                index = protocolContainsWriter(proto:currentProtocol,participant:participant)
            }else if cameFromProtocolSettingsParticipant {
                index = protocolContainsParticipant(proto:currentProtocol,participant:participant)
            }else if cameFromProtocolSettingsDistributor {
                index = protocolContainsDistributor(proto: currentProtocol, participant: participant)
            }
            
            var add = false
            var remove = false
            if index >= 0 {
                remove = true
            }else {
                add = true
            }
            if let entry = currentEntry {
                do{
                    try realm.write {
                        if(add) {
                            entry.concerncs.append(participant)
                            participant.lastAdded = Date()
                        }else if(remove) {
                            entry.concerncs.remove(at: index)
                        }
                    }
                }catch{
                    print(error)
                }
                
            }else if let proto = currentProtocol{
                do{
                    try realm.write {
                        if cameFromProtocolSettings {
                            if add {
                                participant.lastAdded = Date()
                                proto.writers.append(participant)
                            }else if remove {
                                proto.writers.remove(at: index)
                            }
                        }
                        else if cameFromProtocolSettingsParticipant {
                            if add {
                                participant.lastAdded = Date()
                                proto.participants.append(participant)
                            }else if remove {
                                proto.participants.remove(at: index)
                            }
                        }else if cameFromProtocolSettingsDistributor {
                            if add {
                                participant.lastAdded = Date()
                                proto.distributors.append(participant)
                            }else if remove {
                                proto.distributors.remove(at: index)
                            }
                        }
                    }
                }catch{print(error)}
            }
            tableView.reloadData()
        }else {
            performSegue(withIdentifier: "goToImportContacts", sender: self)
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.row == 0 || indexPath.row > sortedParticipants!.count {
            return false
        }
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            let participant = sortedParticipants![indexPath.row - 1]
            
            let deleteConfirmAlert = UIAlertController(title: localization.confirmDeleteTitle, message: localization.confirmDeleteParticipant, preferredStyle: UIAlertController.Style.alert)
            
            deleteConfirmAlert.addAction(UIAlertAction(title: localization.cancel, style: .cancel, handler: { (action: UIAlertAction!) in
                       }))
            deleteConfirmAlert.addAction(UIAlertAction(title: localization.yes, style: .default, handler: { (action: UIAlertAction!) in
              
                
                super.deleteParticipantFromEveryOccurence(participant: participant)
                
                tableView.reloadData()
              }))
            
           

            present(deleteConfirmAlert, animated: true, completion: nil)
        }
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToAddParticipant" {
            let destination = segue.destination as! AddParticipantTableViewController
            destination.calledFromSelectPartcipant = true
        }else if segue.identifier == "goToEditParticipant" {
            let destination = segue.destination as! EditParticipantTableViewController
            destination.participant = self.selParticipant!
        }
    }
    
    var selParticipant : Participant?
    func editParticipant(index : Int) {
        if let participant = sortedParticipants?[index] {
            selParticipant = participant
            performSegue(withIdentifier: "goToEditParticipant", sender: self)
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "addButtonCell") as! AddButtonCell
            return cell
        }else if indexPath.row <= sortedParticipants!.count {
            let cell = tableView.dequeueReusableCell(withIdentifier: "selectParticipantCell", for: indexPath) as! SelectParticipantCell
            let participant = sortedParticipants![indexPath.row - 1]
            
            var shouldBeSelected = false
            if cameFromEntry {
                shouldBeSelected = entryContainsParticipant(entry:currentEntry,participant:participant) >= 0
            }else if cameFromProtocolSettings {
                shouldBeSelected = protocolContainsWriter(proto:currentProtocol,participant:participant) >= 0
            }else if cameFromProtocolSettingsParticipant {
                shouldBeSelected = protocolContainsParticipant(proto:currentProtocol,participant:participant) >= 0
            }else if cameFromProtocolSettingsDistributor {
                shouldBeSelected = protocolContainsDistributor(proto:currentProtocol,participant:participant) >= 0
            }
            
            cell.checkedImg.image = UIImage(named: shouldBeSelected ? "checked" : "unchecked")
            cell.firstname.text = participant.firstName
            cell.lastname.text = participant.lastName
            cell.sign.text = participant.sign
            cell.company.text = participant.company?.name
            cell.index = indexPath.row - 1
            cell.selectParticipantDelegate = self
            
            return cell
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "buttonCell", for: indexPath) as! ButtonCell
            
            cell.button.setTitle("Von Kontakten importieren", for: .normal)
            cell.buttonPressedProtocol = self
            return cell
        }
    }
    
    @objc override func doneItemPressed(){
        dismiss(animated: true, completion: nil)
    }
}


extension SelectParticipantTableViewController : ButtonEvent {
    func pressed() {
        performSegue(withIdentifier: "goToImportContacts", sender: self)
    }
    
    func updatedTextField(index: Int, text: String) {
    }
    
    
}
