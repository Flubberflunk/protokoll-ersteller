//
//  ProtocolSettingsTableViewController.swift
//  com.elbeily.protocol
//
//  Created by Tom el Beily on 17.12.19.
//  Copyright © 2019 Tom el Beily. All rights reserved.
//

import UIKit

class ProtocolSettingsTableViewController: MenuController{
    
    
    
    
    
    var currentProtocol : Protocol?
    var participantsArray = [String]()
    var distributorArray = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "LabelTextBoxCell", bundle: nil), forCellReuseIdentifier:     "labelTextboxCell")
        tableView.register(UINib(nibName: "ProtocolSettingsTableViewCell", bundle: nil), forCellReuseIdentifier: "protocolSettingsCell")
        
        tableView.separatorStyle = .none
        
        writers = getWriters(proto: currentProtocol!)
        participantsArray = getParticipants(proto: currentProtocol!)
        distributorArray = getDistributors(proto: currentProtocol!)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        writers = getWriters(proto: currentProtocol!)
        participantsArray = getParticipants(proto: currentProtocol!)
        distributorArray = getDistributors(proto: currentProtocol!)

        tableView.reloadData()
        addWriter = false
        addParticipant = false
        addDistributor = false
    }
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 5
    }
    
    var projNames = [String]()
    var costNames = [String]()
    var topicNames = [String]()
    var writers = [String]()
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "labelTextboxCell", for: indexPath) as! LabelTextBoxCell
        
        let index = indexPath.row
        cell.label.numberOfLines = 0
        cell.index = index
        cell.settingsButtonEvent = self
        cell.selectionStyle = .none
        if index == 0 {
            cell.label.text = localization.labelCost
            costNames = getCostNames()
            cell.suggestions = costNames
            cell.textField.text = currentProtocol!.costLocation?.name
        }else if index == 1 {
            cell.label.text = localization.labelProjName
            projNames = getProjectNames()
            cell.suggestions = projNames
            cell.textField.text = currentProtocol!.project?.name
        }else if index == 2 {
            cell.label.text = localization.labelTopicName
            topicNames = getTopicNames()
            cell.suggestions = topicNames
            cell.textField.text = currentProtocol!.topic?.name
        }else if index == 3 {
            cell.label.text = localization.labelProtoNr
            cell.textField.text = String(currentProtocol!.nr)
            cell.textField.keyboardType = .numberPad
        }else if index == 4 {
            let settingCell = tableView.dequeueReusableCell(withIdentifier: "protocolSettingsCell", for: indexPath) as! ProtocolSettingsTableViewCell
            
            settingCell.creatorLabel.text = localization.labelCrators
            settingCell.creationLabel.text = localization.labelCreationDate
            settingCell.writerArray = writers
            settingCell.participantArray = participantsArray
            settingCell.distributorArray = distributorArray
            settingCell.datePicker.date = currentProtocol!.date
            settingCell.proto = currentProtocol!
            settingCell.settingsAddWriter = self
            settingCell.writerButton.setTitle(localization.buttonManageCreators, for: .normal)
            settingCell.distributorButton.setTitle(localization.buttonManageDistributors, for: .normal)
            settingCell.manageParticipantButton.setTitle(localization.buttonManageParticipants, for: .normal)
            settingCell.stringPicker.reloadComponent(0)
            settingCell.participantPicker.reloadComponent(0)
            settingCell.distributorPicker.reloadComponent(0)
            settingCell.selectionStyle = .none
            
            return settingCell
        }
        
        return cell
    }
    
    var addWriter = false
    var addDistributor = false
    var addParticipant = false
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "goToSelectParticipant") {
            let destination = segue.destination as! SelectParticipantTableViewController
            if addWriter {
                destination.cameFromProtocolSettings = true
            }else if addParticipant {
                destination.cameFromProtocolSettingsParticipant = true
            }else if addDistributor {
                destination.cameFromProtocolSettingsDistributor = true
            }
            destination.currentProtocol = currentProtocol!
        }
        if "goToHeaderImage" == segue.identifier {
            let destination = segue.destination as! HeaderImageChangeTableViewController
            destination.proto = currentProtocol!
        }
    }
    
}


protocol ProtoSettingsButtonEvent {
    func pressed()
    func updatedTextField(index:Int,text:String)
}

protocol AddWriter {
    func addWriter(proto: Protocol)
    func addParticipant(proto: Protocol)
    func addDistributor(proto: Protocol)
    func goToImageHeader(proto: Protocol)
    
}

extension ProtocolSettingsTableViewController : AddWriter {
    func addWriter(proto: Protocol) {
        self.addWriter = true
        performSegue(withIdentifier: "goToSelectParticipant", sender: self)
    }
    func addParticipant(proto: Protocol) {
        self.addParticipant = true
        performSegue(withIdentifier: "goToSelectParticipant", sender: self)
    }
    
    func addDistributor(proto:Protocol) {
        self.addDistributor = true
        performSegue(withIdentifier: "goToSelectParticipant", sender: self)
        
    }
    
    func goToImageHeader(proto: Protocol) {
        performSegue(withIdentifier: "goToHeaderImage", sender: self)
    }
}

extension ProtocolSettingsTableViewController : ProtoSettingsButtonEvent {
    func pressed() {
        print("pressed")
    }
    
    func updatedTextField(index: Int, text: String) {
        do {
            try realm.write{
                if index == 0 {
                    if costNames.contains(text) {
                        let cost  = realm.objects(CostLocation.self).filter(String(format:"name = '%@'",text)).first!
                        currentProtocol?.costLocation = cost
                    }else {
                        let cost = CostLocation()
                        cost.name = text
                        realm.add(cost)
                        currentProtocol?.costLocation = cost
                    }
                }else if index == 1 {
                    if projNames.contains(text) {
                        let project  = realm.objects(Project.self).filter(String(format:"name = '%@'",text)).first!
                        currentProtocol?.project = project
                    }else {
                        let project = Project()
                        project.name = text
                        realm.add(project)
                        currentProtocol?.project = project
                    }
                }else if index == 2 {
                    if topicNames.contains(text) {
                        let topic  = realm.objects(Topic.self).filter(String(format:"name = '%@'",text)).first!
                        currentProtocol?.topic = topic
                    }else {
                        let topic = Topic()
                        topic.name = text
                        realm.add(topic)
                        currentProtocol?.topic = topic
                    }
                }else if index == 3 {
                    currentProtocol?.nr = Int(text) ?? 0
                }
            }
        }catch{print(error)}
        
    }
    
}
