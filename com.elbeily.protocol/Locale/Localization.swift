//
//  Localization.swift
//  com.elbeily.protocol
//
//  Created by Tom el Beily on 10.12.19.
//  Copyright © 2019 Tom el Beily. All rights reserved.
//
import Foundation

protocol Localization {
    
    //MARK - Participant
    var mail : String {get set}
    var firstname : String {get set}
    var lastName : String {get set}
    var salutation : String {get set}
    var sign : String {get set}
    var company : String {get set}
    var save : String {get set}
    
    //MARK Entry
    var new : String {get set}
    var working : String {get set}
    var done : String {get set}
    var confirmDeleteEntry : String {get set}
    
    //MARK - Protocol
    var noTitleYet : String {get set}
    var confirmDelete : String {get set}
    var confirmDeleteTitle : String {get set}
    
    //MARK - Protocol Settings
    var labelCost : String {get set}
    var labelProjName : String {get set}
    var labelTopicName : String {get set}
    var labelCreationDate : String {get set}
    var labelCrators : String {get set}
    var buttonManageCreators : String {get set}
    var labelProtoNr : String {get set}
    var buttonManageParticipants : String {get set}
    var buttonManageDistributors : String {get set}
    var buttonMamageExecutee : String {get set}
    
    //MARK - Messages
    var errMailMustBeUnique : String {get set}
    var errNotAllRequiredParticipantFieldsWereFilled : String {get set}
    var addedParticipant : String {get set}
    var pleaseEnterValidMailAddress : String {get set}
    var confirmDeleteParticipant : String {get set}
    
    //MARK - Import contact
    var titleContactPermission : String {get set}
    var messageContactPermission : String {get set}
    
    var yes : String {get set}
    var cancel : String {get set}
    var NA : String {get set}
    var no : String{get set}
    var pdfGenerating : String {get set}
    
    var selectImageFromGallery : String {get set}
}

