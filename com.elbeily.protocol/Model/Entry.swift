//
//  Entry.swift
//  com.elbeily.protocol
//
//  Created by Tom el Beily on 10.12.19.
//  Copyright © 2019 Tom el Beily. All rights reserved.
//

import Foundation
import RealmSwift

class Entry : Object {
    @objc dynamic var number = 1.0
    @objc dynamic var content = ""
    @objc dynamic var status = Status.new
    @objc dynamic var dateToExecute = Date()
    @objc dynamic var changeDate = Date()
    let concerncs = List<Participant>()
}

struct Status {
    static let new = "new"
    static let working = "working"
    static let done = "done"
}
