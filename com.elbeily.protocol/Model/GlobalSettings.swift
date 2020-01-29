//
//  GlobalSettings.swift
//  com.elbeily.protocol
//
//  Created by Tom el Beily on 26.12.19.
//  Copyright © 2019 Tom el Beily. All rights reserved.
//

import Foundation
import RealmSwift

class GlobalSettings : Object {
    
    
    @objc dynamic var showCostObject = true
    @objc dynamic var showProjektTitle = true
    @objc dynamic var showTopicName = true
    @objc dynamic var showCompanyName = true
    @objc dynamic var showContact = true
    @objc dynamic var showCompanyState = true
    
    @objc dynamic var companyName = "Firmenname"
    @objc dynamic var contactAddressZipcode = "Postleitzahl"
    @objc dynamic var contactAddressCountry = "Land"
    @objc dynamic var contactAddressState = "Bundesland"
    @objc dynamic var contactAddressStreet = "Straße"
    @objc dynamic var contactAddressTown = "Stadt"
    @objc dynamic var companyContactTele = "555 Telefonnummer"
    @objc dynamic var companyContactMail = "kontakt@firmenname.de"
    
}
