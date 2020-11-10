//
//  ActionButton.swift
//  Me-iOS
//
//  Created by Tcacenco Daniel on 04.09.20.
//  Copyright © 2020 Tcacenco Daniel. All rights reserved.
//

import UIKit

class ActionButton: UIButton {
    
    var actionHandleBlock: ((_ button:ActionButton) -> ())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.isExclusiveTouch = true
        setupButtonAction()
        setupButton()
        
    }
    
    convenience init(){
        self.init(frame: CGRect.zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupButtonAction()
        setupButton()
    }
    
    func setupButtonAction() {
        addTarget(self, action: #selector(triggerAction(sender:)), for: .primaryActionTriggered)
    }
    
    func setupButton() {
        
    }
    
    @objc func triggerAction(sender: ActionButton) {
        actionHandleBlock?(sender)
    }
}
