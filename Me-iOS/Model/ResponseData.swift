//
//  ResponseData.swift
//  Troc
//
//  Created by Tcacenco Daniel on 4/9/19.
//  Copyright © 2019 Tcacenco Daniel. All rights reserved.
//

import Foundation

struct ResponseData<T: Decodable>: Decodable{
    
    var data: T?
     var message : String?
    var error: String?
//    var errors: Errors?
}
