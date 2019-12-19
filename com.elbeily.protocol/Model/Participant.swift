//
//  Participant.swift
//  com.elbeily.protocol
//
//  Created by Tom el Beily on 10.12.19.
//  Copyright © 2019 Tom el Beily. All rights reserved.
//

import Foundation
import RealmSwift

class Participant : Object {
    
    @objc dynamic var salutation : String = ""
    @objc dynamic var firstName : String = ""
    @objc dynamic var lastName : String = ""
    @objc dynamic var mail : String = ""
    @objc dynamic var sign : String = ""
    @objc dynamic var company : Company?
    @objc dynamic var lastAdded : Date = Date()
}
