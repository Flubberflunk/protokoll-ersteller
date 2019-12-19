//
//  EditParticipantTableViewController.swift
//  com.elbeily.protocol
//
//  Created by Tom el Beily on 18.12.19.
//  Copyright © 2019 Tom el Beily. All rights reserved.
//

import UIKit

class EditParticipantTableViewController: MenuController {

    
    var participant : Participant?
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UINib(nibName: "LabelTextBoxCell", bundle: nil), forCellReuseIdentifier:     "labelTextboxCell")
        tableView.register(UINib(nibName: "ButtonCell", bundle: nil), forCellReuseIdentifier: "buttonCell")

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return 6
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "labelTextboxCell", for: indexPath) as! LabelTextBoxCell
        
        if 0 == indexPath.row {
            cell.label.text = localization.salutation
            cell.textField.text = participant!.salutation
        }else if 1 == indexPath.row {
            cell.label.text = localization.firstname
            cell.textField.text = participant!.firstName
        }else if 2 == indexPath.row {
            cell.label.text = localization.lastName
            cell.textField.text = participant!.lastName
        }else if 3 == indexPath.row {
            cell.label.text = localization.mail
            cell.textField.text = participant!.mail
        }else if 4 == indexPath.row {
            cell.label.text = localization.company
            cell.textField.text = participant!.company?.name
            cell.suggestions = getCompanyList() 
        }else if 5 == indexPath.row {
            cell.label.text = localization.sign
            cell.textField.text = participant!.sign
        }
        cell.index = indexPath.row
        cell.proto = self
        

        return cell
    }
    


}


extension EditParticipantTableViewController : ButtonEvent {
    func pressed() {
        
    }
    
    func updatedTextField(index: Int, text: String) {
        do{
            var company : Company?
            if 4 == index {
                company = Company()
                company!.name = text
                company = addCompany(company: company!)
            }
            
            try realm.write {
                if 0 == index{
                    participant?.salutation = text
                }else if 1 == index {
                    participant?.firstName = text
                }else if 2 == index {
                    participant?.lastName = text
                }else if 3 == index {
                    participant?.mail = text
                }else if 4 == index {
                    
                    participant?.company = company!
                }else if 5 == index {
                    participant?.sign = text
                }
            }
        }catch{print(error)}
        
    }
    
    
}
