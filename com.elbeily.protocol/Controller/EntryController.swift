//
//  EntryController.swift
//  com.elbeily.protocol
//
//  Created by Tom el Beily on 13.12.19.
//  Copyright © 2019 Tom el Beily. All rights reserved.
//

import UIKit

class EntryController: MenuController, AddExecutee {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "EntryTableViewCell", bundle: nil), forCellReuseIdentifier: "entryCell")
        tableView.register(UINib(nibName: "AddButtonCell", bundle: nil), forCellReuseIdentifier: "addButtonCell")
        
        NotificationCenter.default.addObserver(self, selector: Selector("keyboardWillShow"), name:UIResponder.keyboardWillShowNotification, object: nil);

        tableView.separatorStyle = .none
        if let prot = selecteProtocol {
//            print(prot)
        }else {
            selecteProtocol = Protocol()
            do {try realm.write{selecteProtocol!.nr = getNextProtoNr() }}catch{print(error)}
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    var selecteProtocol : Protocol?
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    var rows = 0
    var additionalRows = 0
    let additionalAddButtonRow = 1
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let prot = selecteProtocol {
            rows = ( prot.entries.count > 0 ? prot.entries.count : 1 ) + additionalRows + additionalAddButtonRow
        }
        else {
            rows = 1 + additionalAddButtonRow
        }
        return rows
    }
    
    var lastNumber : Double?
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "entryCell", for: indexPath) as! EntryTableViewCell
        
        cell.protocolAddExecutee = self
        cell.localization = localization
        cell.selectionStyle = .none
        if selecteProtocol!.entries.count > indexPath.row {
            let entry = selecteProtocol!.entries[indexPath.row]
            cell.executeDate.date = entry.dateToExecute
            cell.contentTextView.text = entry.content
            cell.nrTextField.text = String(entry.number)
            cell.entry = entry
            cell.designStatus(status: entry.status)
            cell.executeeArr = getConcernList(entry:entry)
            cell.executees.reloadAllComponents()
            lastNumber = entry.number
        }else if rows > indexPath.row + 1{
            
            let entry = Entry()
            let nr = lastNumber ?? 0.90
            let number = nr + 0.10
            entry.number = Double(round(100*number)/100)
            cell.nrTextField.text = String(entry.number)
            cell.entry = entry
            do {
                
                try realm.write {
                    selecteProtocol!.entries.append(cell.entry!)
                    realm.add(selecteProtocol!)
                }
            }catch{print(error)}
            cell.designStatus(status: Status.new)
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "addButtonCell") as! AddButtonCell
            cell.selectionStyle = .none
            return cell
        }
        
        cell.addStatusTappObserver()
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        
        if rows == indexPath.row + 1 {
            print("--------------------------------","button pressed")
            additionalRows = 1
            tableView.reloadData()
            print("new rows",rows)
        }
    }
    
    var segueEntry : Entry?
    func addExecutee(entry: Entry) {
        segueEntry = entry
        performSegue(withIdentifier: "goToSelectParticipant", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "goToSelectParticipant") {
            let destination = segue.destination as! SelectParticipantTableViewController
            destination.cameFromEntry = true
            destination.currentEntry = segueEntry!
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            let deleteConfirmAlert = UIAlertController(title: localization.confirmDeleteTitle, message: localization.confirmDeleteEntry, preferredStyle: UIAlertController.Style.alert)
            
            deleteConfirmAlert.addAction(UIAlertAction(title: localization.cancel, style: .cancel, handler: { (action: UIAlertAction!) in
                       }))
            deleteConfirmAlert.addAction(UIAlertAction(title: localization.yes, style: .default, handler: { (action: UIAlertAction!) in
              
                if let entry = self.selecteProtocol?.entries[indexPath.row] {
                    do{
                        try self.realm.write {
                            self.selecteProtocol!.entries.remove(at: indexPath.row)
                            self.realm.delete(entry)
                            self.additionalRows = 0
                        }
                       
                    }catch{print(error)}
                }
                tableView.reloadData()
              }))
            
           

            present(deleteConfirmAlert, animated: true, completion: nil)
        }
    }
   
    
    @objc func keyboardWillShow(){
//        print("keyboard will be shown")
//        let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
//        let height = window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
//        
//        print(height)
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: -100
, right: 0)

    }
    
    
}


protocol AddExecutee {
    func addExecutee(entry: Entry)
}
