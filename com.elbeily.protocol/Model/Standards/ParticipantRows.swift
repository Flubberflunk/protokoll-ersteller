//
//  ParticipantRows.swift
//  com.elbeily.protocol
//
//  Created by Tom el Beily on 10.12.19.
//  Copyright © 2019 Tom el Beily. All rights reserved.
//

import Foundation


class ParticipantRows {
    
    static let localization = LanguageFactory().getLocalization()
    static let rows = [
        0: ParticipantRows.localization.salutation,
        1: ParticipantRows.localization.firstname,
        2: ParticipantRows.localization.lastName,
        3: ParticipantRows.localization.mail,
        4: ParticipantRows.localization.company,
        5: ParticipantRows.localization.sign
    ]
    
    static var newParticipantValues = [String:String]()
    
    static let isCompany = 4
}
