//
//  DE.swift
//  com.elbeily.protocol
//
//  Created by Tom el Beily on 10.12.19.
//  Copyright © 2019 Tom el Beily. All rights reserved.
//
import Foundation

class DE : Localization {
    
    //MARK - Participant
    var mail = "Mail"
    var firstname = "Vorname"
    var lastName = "Nachname"
    var salutation = "Anrede"
    var sign = "Zeichen"
    var company = "Firma"
    var save = "Speichern"
    
    //MARK - Entry
    var new = "Noch nicht erledigt"
    var working = "In Bearbeitung"
    var done = "Erledigt"
    var confirmDeleteEntry = "Sind Sie sicher, dass Sie diesen Eintrag löschen wollen?"
    
    //MARK - Protocol
    var noTitleYet = "Noch kein Titel"
    var confirmDeleteTitle = "Löschen bestätigen"
    var confirmDelete = "Sind Sie sicher, dass dieses Protokoll gelöscht werden soll?"
    //MARK - Protocol Settings
    var labelCost = "Kostenstelle"
    var labelProjName = "Projektname"
    var labelTopicName = "Themenbereich"
    var labelCreationDate = "Erstellungsdatum"
    var labelCrators = "Ersteller"
    var buttonManageCreators = "Ersteller bearbeiten"
    var labelProtoNr = "Besprechungprotokoll Nr."
    var buttonManageParticipants = "Teilnehmer bearbeiten"
    var buttonManageDistributors = "Verteiler bearbeiten"
    var buttonMamageExecutee = "Zuständige bearbeiten"
    
    //MARK - Messages
    var errMailMustBeUnique = "Die Mail Adresse wurde bereits genutzt."
    var errNotAllRequiredParticipantFieldsWereFilled = "Bitte füllen Sie alle Felder mit * markiert aus."
    var addedParticipant = "Der Teilnehmer wurde hinzugefügt."
    var pleaseEnterValidMailAddress = "Bitte gebeb Sie eine gültige Mail Addresse ein."
    var confirmDeleteParticipant = "Wenn Sie diesen Kontakt löschen, wird er auch, sofern vorhanden, aus allen anderen Objekten entfertn. Wollen Sie fortfahren?"
    var pdfGenerating = "Wird erstellt..."
    
    //MARK - Import contact
    var titleContactPermission = "Berechtigungen"
    var messageContactPermission = "Um Kontakte importieren zu können, muss die Berechtigung erteilt werden. Wollen Sie dies jetzt tun?"
    
    
    
    var yes = "Ja"
    var no = "Nein"
    var cancel = "Abbrechen"
    var NA = "N/A"
    
    var selectImageFromGallery = "Eigenes Bild auswählen."
    var changeHeaderImage = "Header Bild wechseln"
    
    var showCostObjectLabel = "Kostenstellen"
    var showProjektTitleLabel = "Projekt Titel"
    var showTopicNameLabel = "Kategorie"
    var showCompanyNameLabel = "Firmenname"
    var showContactAddressLabel = "Anschrift und Kontakt"
    var companyNameLabel = "Zegie Firmenname"
    var contactAddressLabel = "Zeige Anschrift"
    var contactAddressCountryLabel = "Land"
    var contactAddressZipcodeLabel = "Postleitzahl"
    var contactAddressStateLabel = "Bundesland"
    var contactAddressTownLabel = "Stadt"
    var contactAddressStreetLabel = "Straße"
    var companyContactTeleLabel = "Telefon"
    var companyContactMailLabel = "Mail"
}
