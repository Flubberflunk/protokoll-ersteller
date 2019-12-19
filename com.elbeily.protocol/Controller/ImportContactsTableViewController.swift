//
//  ImportContactsTableViewController.swift
//  com.elbeily.protocol
//
//  Created by Tom el Beily on 18.12.19.
//  Copyright © 2019 Tom el Beily. All rights reserved.
//

import UIKit
import RealmSwift
import ContactsUI

class ImportContactsTableViewController: MenuController {
    
    var importedContacts = List<Participant>()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "SelectParticipantCell", bundle: nil), forCellReuseIdentifier: "selectParticipantCell")
        importContacts()
        if(importedContacts.count == 0) {
            checkIfContactPermissionsAreAvailable()
        }
        
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return importedContacts.count
    }
    
    
    var shouldBeSelected = [Int:Bool]()
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "selectParticipantCell", for: indexPath) as! SelectParticipantCell
        
        let contact = importedContacts[indexPath.row]
        cell.checkedImg.image = UIImage(named: shouldBeSelected[indexPath.row] ?? false ? "checked" : "unchecked")
        cell.firstname.text = contact.firstName
        cell.lastname.text = contact.lastName
        cell.sign.text = contact.sign
        cell.company.text = contact.company?.name
        
        return cell
    }
    
    func particpantExists(index: Int, contact : Participant) -> Bool{
        do {
            return try realm.objects(Participant.self).filter(String(format:"firstName = '%@' AND lastName = '%@' AND sign = '%@'",contact.firstName, contact.lastName, contact.sign)).count > 0
            
        }
        catch{print(error)
            return false
        }
    }
    
    func checkIfContactPermissionsAreAvailable(){
        switch CNContactStore.authorizationStatus(for: .contacts) {
        case .authorized:
            importContacts()
            break
        case .denied:
            reaskPermission()
            break
        default:
            reaskPermission()
            break
        }
        
        
    }
    
    func reaskPermission(){
        let contactPermission = UIAlertController(title: localization.titleContactPermission, message: localization.messageContactPermission, preferredStyle: UIAlertController.Style.alert)
        
        contactPermission.addAction(UIAlertAction(title: localization.no, style: .cancel, handler: { (action: UIAlertAction!) in
            
            _ = self.navigationController?.popViewController(animated: true)
        }))
        contactPermission.addAction(UIAlertAction(title: localization.yes, style: .default, handler: { (action: UIAlertAction!) in
            
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
        }))
        
        present(contactPermission, animated: true, completion: nil)
    }
    
    
    func importContacts(){
        importedContacts = getContacts()
        var cnt = 0
        for contact in importedContacts {
            shouldBeSelected[cnt] = particpantExists(index: cnt, contact: contact)
            cnt += 1
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.row
        shouldBeSelected[index] = !(shouldBeSelected[index] ?? false)
        
        
        if shouldBeSelected[index]! {
            do{
                try realm.write {
                    if !particpantExists(index: index, contact: importedContacts[index]) {
                        realm.add(importedContacts[index])
                    }
                }
            }catch{print(error)}
        }
        
        tableView.reloadData()
    }
}
