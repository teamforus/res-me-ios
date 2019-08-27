//
//  Transaction.swift
//  Me-iOS
//
//  Created by Tcacenco Daniel on 5/16/19.
//  Copyright © 2019 Tcacenco Daniel. All rights reserved.
//

import Foundation

struct Transaction: Decodable {
    
    var organization_id: Int?
    var product_id: Int?
    var fund_id: Int?
    var amount: String?
    var address: String?
    var organization: Organization?
    var product: Product?
    var created_at: String?
    var date_time: String?
}
