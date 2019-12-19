//
//  Topic.swift
//  com.elbeily.protocol
//
//  Created by Tom el Beily on 10.12.19.
//  Copyright © 2019 Tom el Beily. All rights reserved.
//

import Foundation
import RealmSwift

class Topic : Object {
    
    @objc dynamic var name = ""
    @objc dynamic var lastUsed = Date()
}
