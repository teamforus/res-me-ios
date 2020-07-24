//
//  Record.swift
//  Me-iOS
//
//  Created by Tcacenco Daniel on 5/27/19.
//  Copyright © 2019 Tcacenco Daniel. All rights reserved.
//

import Foundation

struct Record: Decodable {

    var id: Int?
    var value: String?
    var order: Int?
    var deleted: Bool?
    var name: String?
    var key: String?
    var record_category_id: Int?
    var validations: [Validator]?
}
