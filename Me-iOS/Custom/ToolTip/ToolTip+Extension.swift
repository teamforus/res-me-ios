//
//  ToolTip+Extension.swift
//  Me-iOS
//
//  Created by Development Kingdom on 23.09.2020
//  Copyright © 2020 Tcacenco Daniel. All rights reserved.
//

import UIKit

extension UIView {
    
    func removeToolTip(with message: String) {
        if let tooltip = ToolTipTracker.shared.tooltip(for: message) {
           tooltip.dismiss()
       }
    }
    
    func toolTip(superview: UIView? = nil, message: String, style: ToolTip.Style = .dark, location: ToolTip.Location = .none, offset: CGPoint? = nil, forceShow: Bool = false) {
        
        if let tooltip = ToolTipTracker.shared.tooltip(for: message) {
            if forceShow {
                tooltip.dismiss()
            } else {
                return
            }
        }
        
        guard let superview = superview ?? self.superview else { return }
        let anchor = self
        superview.toolTip(anchor: anchor, message: message, style: style, location: location, offset: offset, forceShow: forceShow)
    }
    
    func toolTip(anchor: UIView, message: String, style: ToolTip.Style = .dark, location: ToolTip.Location = .none, offset: CGPoint? = nil, forceShow: Bool = false) {
        
        if let tooltip = ToolTipTracker.shared.tooltip(for: message) {
            if forceShow {
                tooltip.dismiss()
            } else {
                return
            }
        }
        
        let tooltip = ToolTip(message: message, style: style, location: location)
        tooltip.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(tooltip)
        self.bringSubviewToFront(tooltip)
        switch location {
        case .bottom:
            NSLayoutConstraint.activate([
                tooltip.centerXAnchor.constraint(equalTo: anchor.centerXAnchor, constant: offset?.x ?? 0.0),
                tooltip.topAnchor.constraint(equalTo: anchor.bottomAnchor, constant: offset?.y ?? 0.0),
            ])
        case .top:
            NSLayoutConstraint.activate([
                tooltip.centerXAnchor.constraint(equalTo: anchor.centerXAnchor, constant: offset?.x ?? 0.0),
                tooltip.bottomAnchor.constraint(equalTo: anchor.topAnchor, constant: offset?.y ?? 0.0),
            ])
        case .right:
            NSLayoutConstraint.activate([
                tooltip.centerYAnchor.constraint(equalTo: anchor.centerYAnchor, constant: offset?.y ?? 0.0),
                tooltip.leadingAnchor.constraint(equalTo: anchor.trailingAnchor, constant: offset?.x ?? 0.0),
            ])
        case .left:
            NSLayoutConstraint.activate([
                tooltip.centerYAnchor.constraint(equalTo: anchor.centerYAnchor, constant: offset?.y ?? 0.0),
                tooltip.trailingAnchor.constraint(equalTo: anchor.leadingAnchor, constant: offset?.x ?? 0.0),
            ])
        case .none: ()
            NSLayoutConstraint.activate([
                tooltip.centerYAnchor.constraint(equalTo: anchor.centerYAnchor, constant: offset?.y ?? 0.0),
                tooltip.centerXAnchor.constraint(equalTo: anchor.centerXAnchor, constant: offset?.x ?? 0.0),
            ])
        }
        
        ToolTipTracker.shared.append(tooltip: tooltip)
    }
    
    
}
