//
//  Fund.swift
//  Me-iOS
//
//  Created by Tcacenco Daniel on 5/16/19.
//  Copyright © 2019 Tcacenco Daniel. All rights reserved.
//

import Foundation

enum FundType: String {
    case subsidies = "subsidies"
}

struct Fund: Decodable {
    
    var id: Int?
    var name: String?
    var state: String?
    var currency: String?
    var url_webshop: String?
    var organization: Organization?
    var type: String?
    var product_categories: [ProductCategory]?
    var logo: Logo?
}
