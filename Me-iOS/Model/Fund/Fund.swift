//
//  Fund.swift
//  Me-iOS
//
//  Created by Tcacenco Daniel on 5/16/19.
//  Copyright © 2019 Tcacenco Daniel. All rights reserved.
//

import Foundation

struct Fund: Decodable {
    
    var id: Int?
    var name: String?
    var state: String?
    var currency: String?
    var url_webshop: String?
    var organization: Organization?
    var product_categories: [ProductCategory]?
    var logo: Logo?
}
