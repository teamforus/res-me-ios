//
//  Office.swift
//  Me-iOS
//
//  Created by Tcacenco Daniel on 5/16/19.
//  Copyright © 2019 Tcacenco Daniel. All rights reserved.
//

import Foundation

struct Office: Decodable {
    
    var id: Int?
    var address: String?
    var phone: String?
    var lon: String?
    var lat: String?
    var organization: Organization?
    var photo: Logo?
    var wallet: Wallet?
}


