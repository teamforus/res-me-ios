//
//  ToolTipTracker.swift
//  Me-iOS
//
//  Created by Development Kingdom on 23.09.2020
//  Copyright © 2020 Tcacenco Daniel. All rights reserved.
//

import Foundation

class ToolTipTracker {
    static let shared = ToolTipTracker()
    
    private var tooltips = [String: WeakRef<ToolTip>]()
    
    func tooltip(for message: String) -> ToolTip? {
        return tooltips[message]?.value
    }
    
    func append(tooltip: ToolTip) {
        tooltips[tooltip.message] = WeakRef(value: tooltip)
    }
    
    func dismiss(message: String) {
        tooltips[message]?.value?.dismiss()
        tooltips.removeValue(forKey: message)
    }
    
    func dismissAll() {
        for (_, tooltip) in tooltips {
            tooltip.value?.dismiss()
        }
        
        tooltips.removeAll()
    }
}
