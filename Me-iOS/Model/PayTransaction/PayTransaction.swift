//
//  PayTransaction.swift
//  Me-iOS
//
//  Created by Tcacenco Daniel on 6/6/19.
//  Copyright © 2019 Tcacenco Daniel. All rights reserved.
//

import Foundation


struct PayTransaction: Encodable {
    
    var organization_id: Int?
    var amount: String?
    var note: String?
}
