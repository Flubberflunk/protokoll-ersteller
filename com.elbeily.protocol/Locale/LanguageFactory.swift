//
//  LanguageFactory.swift
//  com.elbeily.protocol
//
//  Created by Tom el Beily on 10.12.19.
//  Copyright © 2019 Tom el Beily. All rights reserved.
//

import Foundation

enum LanguageTypes {
    case DE
    case EN
}

class LanguageFactory {
    
    private static var sharedLanguageFactory = LanguageFactory()
    private var currentLanguage : LanguageTypes
    
    init() {
        

        let currentLanguageString : String = LanguageFactory.getStdLang()
        
        switch currentLanguageString {
        case "en":
            self.currentLanguage = LanguageTypes.EN
            break
        case "de":
            self.currentLanguage = LanguageTypes.DE
            break
        default:
            self.currentLanguage = LanguageTypes.EN
        }
    }
    
    static func getStdLang()->String{
        //        let currentLanguageString : String = NSLocale.current.languageCode ?? "de"
        
        return "de"
    }
    
    class func shared() -> LanguageFactory {
        return sharedLanguageFactory
    }
    
  
    
    
    func getLocalization() -> Localization{
        switch self.currentLanguage {
            case .EN:
                return DE()//EN()
            case .DE:
                return DE()
        }
        
    }
}



