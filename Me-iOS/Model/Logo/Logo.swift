//
//  Logo.swift
//  Me-iOS
//
//  Created by Tcacenco Daniel on 5/16/19.
//  Copyright © 2019 Tcacenco Daniel. All rights reserved.
//

import Foundation


struct Logo: Decodable, Hashable {
    
    var uid: String?
    var original_name: String?
    var type: String?
    var ext: String?
    var sizes: Size?
}

struct Size: Decodable, Hashable {
    
    var thumbnail: String?
    var large: String?
}
