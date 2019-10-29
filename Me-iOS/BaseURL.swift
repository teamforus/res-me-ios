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
        return "https://dev.api.forus.io/api/v1/\(url)"
        #elseif ALPHA
        return "https://lab.api.forus.io/api/v1/\(url)"
        #elseif DEMO
        return "https://demo.api.forus.io/api/v1/\(url)"
        #else
        return "https://api.forus.link/api/v1/\(url)"
        #endif
        
    }
    
    static func getBaseURL() -> String{
        #if DEV
        return "dev.api.forus.io"
        #elseif ALPHA
        return "staging.api.forus.io"
        #elseif DEMO
        return "demo.api.forus.link"
        #else
        return "api.forus.link"
        #endif
    }
}
