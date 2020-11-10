//
//  WeakRef.swift
//  Me-iOS
//
//  Created by Development Kingdom on 23.09.20.
//  Copyright © 2020 Tcacenco Daniel. All rights reserved.
//

import Foundation

import Foundation

class WeakRef<T> where T: AnyObject {

    private(set) weak var value: T?

    init(value: T?) {
        self.value = value
    }
}
