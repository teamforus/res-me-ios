//
//  RoundImageView.swift
//  Me
//
//  Created by Tcacenco Daniel on 8/27/18.
//  Copyright © 2018 Foundation Forus. All rights reserved.
//

import UIKit

@IBDesignable
class RoundImageView: UIImageView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)!
        self.layer.masksToBounds = false
        
        self.layer.cornerRadius = self.frame.height/2
        self.clipsToBounds = true
    }
    
}
