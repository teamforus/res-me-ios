//
//  PinCode.swift
//  Me-iOS
//
//  Created by Tcacenco Daniel on 5/6/19.
//  Copyright © 2019 Tcacenco Daniel. All rights reserved.
//

import Foundation

struct PinCode: Decodable {
    
    var auth_code: Int?
    var exchange_token: String?
    var access_token: String?
}
