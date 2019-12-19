//
//  HomeTableViewController.swift
//  com.elbeily.protocol
//
//  Created by Tom el Beily on 10.12.19.
//  Copyright © 2019 Tom el Beily. All rights reserved.
//

import UIKit
import RealmSwift

class HomeTableViewController: MenuController {

    var allProtocols : Results<Protocol>?

    override func viewDidLoad() {
        super.viewDidLoad()
        super.addTopBarAddItem()
        tableView.register(UINib(nibName: "ProtocolTableViewCell", bundle: nil), forCellReuseIdentifier: "protocolCell")
        
        allProtocols = getProtocols()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        allProtocols = getProtocols()
        tableView.reloadData()
    }
    
    override func addItem() {
//        performSegue(withIdentifier: "goToAddParticipant", sender: self)
        segueProtocol = nil
        performSegue(withIdentifier: "goToAddEntry", sender: self)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return allProtocols?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "protocolCell", for: indexPath) as! ProtocolTableViewCell
        
        if let protos = allProtocols {
            let proto = protos[indexPath.row]
            cell.index = indexPath.row 
            cell.creatorLabel.text = ""
            cell.homeControllerDelegate = self
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat  = "dd.MM.yyyy"
            let stringDate = dateFormatter.string(from: proto.date)
            cell.dateLabel.text = stringDate
            cell.selectionStyle = .none
            for creator in proto.writers {
                if creator.mail == proto.writers.last?.mail {
                    cell.creatorLabel.text! += String(format: "%@",creator.sign)
                }else {
                    cell.creatorLabel.text! += String(format: "%@, ",creator.sign)
                }
            }
            cell.objectLabel.text! = proto.project?.name ?? localization.noTitleYet
        }
        
        return cell
    }
    
    var segueIndex : Int?
    var segueProtocol : Protocol?
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        segueProtocol = allProtocols![indexPath.row]
        performSegue(withIdentifier: "goToAddEntry", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "goToAddEntry") {
            let destination = segue.destination as! EntryController
            if let proto = segueProtocol {
                destination.selecteProtocol = proto
            }
        }
        else if segue.identifier == "goToPanelSettings" {
            let destination = segue.destination as! ProtocolSettingsTableViewController
            let proto = allProtocols![segueIndex!]
            destination.currentProtocol = proto
        }else if segue.identifier == "goToPDFPreview" {
            let destination = segue.destination as! PDFPreviewTableViewController
            let proto = allProtocols![segueIndex!]
            destination.currentProtocol = proto
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            let deleteConfirmAlert = UIAlertController(title: localization.confirmDeleteTitle, message: localization.confirmDelete, preferredStyle: UIAlertController.Style.alert)
            
            deleteConfirmAlert.addAction(UIAlertAction(title: localization.cancel, style: .cancel, handler: { (action: UIAlertAction!) in
                       }))
            deleteConfirmAlert.addAction(UIAlertAction(title: localization.yes, style: .default, handler: { (action: UIAlertAction!) in
              
                if let protos = self.allProtocols {
                    let proto = protos[indexPath.row]
                    do{
                        try self.realm.write {
                             for entry in proto.entries {
                                self.realm.delete(entry)
                            }
                            self.realm.delete(proto)
                        }
                       
                    }catch{print(error)}
                }
                
                tableView.reloadData()
              }))
            
           

            present(deleteConfirmAlert, animated: true, completion: nil)
        }
    }
    
}

