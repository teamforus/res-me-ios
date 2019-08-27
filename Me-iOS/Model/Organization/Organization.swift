//
//  Organization.swift
//  Me-iOS
//
//  Created by Tcacenco Daniel on 5/16/19.
//  Copyright © 2019 Tcacenco Daniel. All rights reserved.
//

import Foundation

struct Organization: Decodable, Hashable {
    
    var id: Int?
    var organization_id: Int?
    var identity_address: String?
    var name: String?
    var iban: String?
    var email: String?
    var categories: String?
    var phone: String?
    var kvk: String?
    var btw: String?
    var logo: Logo?
    var permissions: [String]?
    var product_categories: [ProductCategory]?
}
