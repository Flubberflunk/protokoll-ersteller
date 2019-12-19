//
//  Protocol.swift
//  com.elbeily.protocol
//
//  Created by Tom el Beily on 10.12.19.
//  Copyright © 2019 Tom el Beily. All rights reserved.
//

import Foundation
import RealmSwift

class Protocol : Object {
    
    @objc dynamic var nr = -1
    @objc dynamic var date = Date()
    @objc dynamic var lastAccessed = Date()
    @objc dynamic var number = "0"
    @objc dynamic var costLocation : CostLocation?
    @objc dynamic var project : Project?
    @objc dynamic var topic : Topic?
    
    let participants = List<Participant>()
    let writers = List<Participant>()
    let entries = List<Entry>()
    let distributors = List<Participant>()
}
