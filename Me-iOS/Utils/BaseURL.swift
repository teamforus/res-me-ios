//
//  BaseURL.swift
//  MeApp
//
//  Created by Tcacenco Daniel on 6/1/18. 
//  Copyright © 2018 Tcacenco Daniel. All rights reserved.
//

import Foundation

class BaseURL {
    
    static func baseURL(url:String) -> String{
        #if DEV
        return "\(UserDefaults.standard.string(forKey: UserDefaultsName.EnvironmentURL)!)\(url)"
        #elseif ALPHA
        return "https://staging.api.forus.io/api/v1/\(url)"
        
        #elseif DEMO
        return "https://demo.api.forus.io/api/v1/\(url)"
        #else
        return "https://api.forus.io/api/v1/\(url)"
        #endif
        
    }
    
    static func getBaseURL() -> String{
        #if DEV
        return "dev.api.forus.io"
        #elseif ALPHA
        return "staging.test.api.forus.io"
        #elseif DEMO
        return "demo.api.forus.link"
        #else
        return "api.forus.io"
        #endif
    }
}
