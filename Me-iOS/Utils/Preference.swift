//
//  Preference.swift
//  Me-iOS
//
//  Created by Development Kingdom on 23.09.20.
//  Copyright © 2020 Tcacenco Daniel. All rights reserved.
//

import Foundation

class Preference {
    
    public static var tapToSeeTransactionTipHasShown: Bool {
        get {
            return tapToSeeTransactionTipHasShownCount == 1
        }
        set {
            if newValue {
                tapToSeeTransactionTipHasShownCount = tapToSeeTransactionTipHasShownCount + 1
            } else {
                tapToSeeTransactionTipHasShownCount = tapToSeeTransactionTipHasShownCount - 1
            }
        }
    }
    
    private static var tapToSeeTransactionTipHasShownCount: Int {
        get {
            return UserDefaults.standard.integer(forKey: UserDefaultsName.tapToSeeTransactionTipHasShownCount)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaultsName.tapToSeeTransactionTipHasShownCount)
        }
    }
    
    public static var userHasCloseUpdateNotifier: Bool {
        get {
            return UserDefaults.standard.bool(forKey: UserDefaultsName.userHasCloseUpdateNotifier)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaultsName.userHasCloseUpdateNotifier)
        }
    }
}
