//
//  MenuController.swift
//  com.elbeily.protocol
//
//  Created by Tom el Beily on 10.12.19.
//  Copyright © 2019 Tom el Beily. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework
import ContactsUI

class MenuController: UITableViewController {
    
    
    
    var globalSettings : GlobalSettings?
    
    let realm = try! Realm()
    let localization = LanguageFactory().getLocalization()
    var participants : Results<Participant>?
    var companies : Results<Company>?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showMeInFullScreen()
        hideBackButtonTitle()
        getGlobalSettings()
    }
    
    func addDoneBarItem(){
        navigationItem.leftBarButtonItem = UIBarButtonItem.menuButton(self, action: #selector(doneItemPressed), imageName: "checked")
        //               navigationController?.navigationBar.tintColor = DialegoColors.stdCellTextColor
        //               navigationItem.leftBarButtonItem?.tintColor = DialegoColors.primaryOrange
        navigationItem.leftItemsSupplementBackButton = true
    }
    
    @objc func doneItemPressed(){
//        print("doneItemOressed")
    }
    
    func addTopBarAddItem(){
        navigationItem.leftBarButtonItem = UIBarButtonItem.menuButton(self, action: #selector(addItem), imageName: "add")
        navigationItem.leftItemsSupplementBackButton = true
    }
    
    @objc func addItem() {
//        print("add item")
    }
    
    func getGlobalSettings() {
        globalSettings = realm.objects(GlobalSettings.self).first
        if nil == globalSettings {
            do{
                try realm.write {
                    globalSettings = GlobalSettings()
                    realm.add(globalSettings!)
                }
            }catch{print(error)}
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
    
    func showMeInFullScreen(){
        self.modalPresentationStyle = .fullScreen
    }
    
    func hideBackButtonTitle(){
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    // MARK : Realm Functions
    
    func getCompanies() {
        
        companies = realm.objects(Company.self)
    }
    
    func getCostNames()->[String]{
        let costs = realm.objects(CostLocation.self)
        var costStrings = [String]()
        
        for cost in costs {
            costStrings.append(cost.name)
        }
        
        return costStrings
    }
    
    func getTopicNames()->[String]{
        let topics = realm.objects(Topic.self)
        var topicString = [String]()
        
        for topic in topics {
            topicString.append(topic.name)
        }
        
        return topicString
    }
    
    func getProjectNames()->[String]{
        let projects = realm.objects(Project.self)
        var projectString = [String]()
        
        for project in projects {
            projectString.append(project.name)
        }
        
        return projectString
    }
    
    func getCompanyList() -> [String] {
        getCompanies()
        var companyList = [String]()
        
        if let allCompanies = companies {
            for company in allCompanies {
                companyList.append(company.name)
            }
        }
        
        return companyList
    }
    
    func  getWriters(proto: Protocol) -> [String] {
        var arrWriters = [String]()
        
        for writer in proto.writers {
            arrWriters.append(String(format: "%@ %@ - %@",writer.firstName, writer.lastName, writer.sign))
        }
        
        return arrWriters
    }
    
    func getParticipants(proto: Protocol) -> [String] {
        var arrParticipants = [String]()
        for partic in proto.participants {
            arrParticipants.append(String(format: "%@ %@ - %@",partic.firstName, partic.lastName, partic.sign))
        }
        
        return arrParticipants
    }
    func getDistributors(proto: Protocol) -> [String] {
        var arrDistributors = [String]()
        for distributor in proto.distributors {
            arrDistributors.append(String(format: "%@ %@ - %@",distributor.firstName, distributor.lastName, distributor.sign))
        }
        
        return arrDistributors
    }
    
    
    
    
    func getConcernList(entry: Entry) -> [String] {
        var concerns = [String]()
        
        for concern in entry.concerncs {
            concerns.append(String(format:"%@ %@ - %@",concern.firstName,concern.lastName,concern.sign))
        }
        
        return concerns
    }
    
    func companyExists(companyName : String) -> Bool {
        let companies = realm.objects(Company.self).filter(String(format:"name = '%@'",companyName))
        return companies.count > 0
    }
    
    
    func addCompany(company : Company) -> Company{
        if companyExists(companyName: company.name) {
            return realm.objects(Company.self).filter(String(format:"name = '%@'",company.name)).first!
        }
        do{
            try realm.write {
                realm.add(company)
            }
        }catch{print(error)}
        
        return company
    }
    
    func addParticipant(participant : Participant) {
        do{
            try realm.write {
                realm.add(participant)
            }
        }catch{print(error)}
    }
    
    func participantIsUnique(participant: Participant) -> Bool {
        
        let participants = realm.objects(Participant.self).filter(String(format:"sign = '%@' and mail = '%@'",participant.sign,participant.mail))
        return participants.count == 0
    }
    
    func getProtocols(lastAccessed : Bool = true)->Results<Protocol>{
        let unsortedProtocols = realm.objects(Protocol.self)
        var sortBy = ""
        if lastAccessed {
            sortBy = "lastAccessed"
        }else {
            sortBy = "date"
        }
        
        let protocols = unsortedProtocols.sorted(byKeyPath: sortBy,ascending: true)
        
        return protocols
    }
    
    func validateEmail(enteredEmail:String) -> Bool {
        
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: enteredEmail)
        
    }
    
    func entryContainsParticipant(entry potentialEntry: Entry?, participant: Participant)->Int {
        var index = 0
        if let entry = potentialEntry {
            for concern in entry.concerncs {
                if concern.mail == participant.mail &&
                    concern.firstName == participant.firstName &&
                    concern.lastName == participant.lastName &&
                    concern.sign == participant.sign{
                    return index
                }
                index += 1
            }
        }
        return -1
    }
    
    func protocolContainsWriter(proto potentialProto: Protocol?, participant: Participant)->Int {
        var index = 0
        if let proto = potentialProto {
            for writer in proto.writers {
                if writer.mail == participant.mail  &&
                    writer.firstName == participant.firstName &&
                    writer.lastName == participant.lastName &&
                    writer.sign == participant.sign{
                    return index
                }
                index += 1
            }
        }
        return -1
    }
    
    func protocolContainsParticipant(proto potentialProto: Protocol?, participant: Participant)->Int {
        var index = 0
        if let proto = potentialProto {
            for part in proto.participants {
                if part.mail == participant.mail  &&
                    part.firstName == participant.firstName &&
                    part.lastName == participant.lastName &&
                    part.sign == participant.sign{
                    return index
                }
                index += 1
            }
        }
        return -1
    }
    
    func protocolContainsDistributor(proto potentialProto: Protocol?, participant: Participant)->Int {
        var index = 0
        if let proto = potentialProto {
            for distributor in proto.distributors {
                if distributor.mail == participant.mail &&
                    distributor.firstName == participant.firstName &&
                    distributor.lastName == participant.lastName &&
                    distributor.sign == participant.sign{
                    return index
                }
                index += 1
            }
        }
        return -1
    }
    
    
    
    func getContacts(filter: String = "") -> List<Participant> {
        
        let filter = filter.lowercased()
        let deviceContacts = List<Participant>()
        let contacts = PhoneContacts.getContacts()
        
        for contact in contacts {
            let firstName = contact.givenName.replacingOccurrences(of: "'", with: "")
            let lastName = contact.familyName.replacingOccurrences(of: "'", with: "")
            
           
            
            let participant = Participant()
            participant.firstName = firstName
            participant.lastName = lastName
            
            if firstName.count > 0 && lastName.count > 0 {
                let sign = String(format: "%@%@", String(firstName.first!)  , String(lastName.first!))
                participant.sign = sign
            }
            
            var mail = ""
            if let email = contact.emailAddresses.first?.value as String? {
                participant.mail = email
                mail = email
            }
            let companyName = contact.organizationName
            
            if companyName.count > 0 {
                var company = Company()
                company.name = companyName
                
                company = addCompany(company: company)
                participant.company = company
                
            }
            if(filter != "" && !firstName.lowercased().contains(filter) && !lastName.lowercased().contains(filter)  && !companyName.lowercased().contains(filter) &&  !mail.lowercased().contains(filter)) {
               continue
           }
            
            
            deviceContacts.append(participant)
        }
        
        return deviceContacts
    }
    
    func sortEntry(_ entries : List<Entry>) -> List<Entry>{
        let sorted = List<Entry>()
        var smallestTmp : Double = Double.greatestFiniteMagnitude
        var tmpEntry : Entry?
        var added = [Int]()
        var addedIndex = 0
        var outerCnt = 0;
        var innerCnt = 0;
        for _ in entries {
            innerCnt = 0
            for e in entries {
                if (e.number <= smallestTmp) {
                    if(!added.contains(innerCnt))
                    {
                        smallestTmp = e.number
                        tmpEntry = e
                        addedIndex = innerCnt
                    }
                }
                innerCnt += 1
                
            }
            smallestTmp = Double.greatestFiniteMagnitude
            sorted.append(tmpEntry!)
            added.append(addedIndex)
            outerCnt += 1
        }
        
        return sorted
    }
    
    func deleteParticipantFromEveryOccurence(participant : Participant) {
        
        let allProtocols = getProtocols()
        
        for proto in allProtocols {
            
            for list in [proto.writers, proto.distributors, proto.participants] {
                deleteParticipantFromListIfFound(list: list, participant: participant)
            }
            for entry in proto.entries {
                for list in [entry.concerncs] {
                    deleteParticipantFromListIfFound(list: list, participant: participant)
                }
            }
        }
        
        do{
            try realm.write {
                realm.delete(participant)
            }
        }catch{print(error)}
    }
    
    func deleteParticipantFromListIfFound(list participants: List<Participant>, participant searchFor: Participant){
        
        var cnt = 0
        for participant in participants {
//            print(participant == searchFor)
            if participant.company?.name == searchFor.company?.name &&
            participant.firstName == searchFor.firstName &&
            participant.lastName == searchFor.lastName &&
            participant.mail == searchFor.mail &&
            participant.salutation == searchFor.salutation &&
            participant.sign == searchFor.sign {
                do {
                    try self.realm.write{
                        participants.remove(at: cnt)
                    }
                }catch{print(error)}
            }
            cnt += 1
        }
    }
    
    func getSavedImage(named: String) -> UIImage? {
        if let dir = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) {
            return UIImage(contentsOfFile: URL(fileURLWithPath: dir.absoluteString).appendingPathComponent(named).path)
        }
        return nil
    }
    
    func getHeaderImageForProto() -> UIImage{
        
        let image = getSavedImage(named: "custom-header")
        if let img = image {
            return img
        }
        
        return UIImage(named: "def_header")!
    }
    
    func getNextProtoNr() -> Int{
        let allProtocols = getProtocols()

        var nr = 1
        for proto in allProtocols {
            let protoNr = proto.nr
            if protoNr >= nr {
                nr = protoNr + 1
            }
        }
        
        return nr
    }
    
    
    let child = SpinnerViewController()
    func createSpinnerViewAndShow() {
        addChild(child)
        child.view.frame = view.frame
        view.addSubview(child.view)
        child.didMove(toParent: self)

    }
    func removeSpinner(){
        self.child.willMove(toParent: nil)
        self.child.view.removeFromSuperview()
        self.child.removeFromParent()
    }
    
}


extension UIBarButtonItem {
    
    static func menuButton(_ target: Any?, action: Selector, imageName: String) -> UIBarButtonItem {
        let button = UIButton(type: .system)
        
        button.setImage(UIImage(named: imageName), for: .normal)
        button.addTarget(target, action: action, for: .touchUpInside)
        button.layoutIfNeeded()
        
        let menuBarItem = UIBarButtonItem(customView: button)
        
        menuBarItem.customView?.translatesAutoresizingMaskIntoConstraints = false
        menuBarItem.customView?.heightAnchor.constraint(equalToConstant: 24).isActive = true
        menuBarItem.customView?.widthAnchor.constraint(equalToConstant: 24).isActive = true
        
        return menuBarItem
    }
}


class SpinnerViewController: UIViewController {
    var spinner = UIActivityIndicatorView(style: .large)

    override func loadView() {
        view = UIView()
        view.backgroundColor = UITraitCollection.current.userInterfaceStyle == .dark ? UIColor.black : UIColor.white
        
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.startAnimating()
        view.addSubview(spinner)

        spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
}
