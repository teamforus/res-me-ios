//
//  DynamicLabel.swift
//  Me-iOS
//
//  Created by Tcacenco Daniel on 20.05.20.
//  Copyright © 2020 Tcacenco Daniel. All rights reserved.
//

import UIKit

class DynamicLabel: UILabel {

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupDynamic()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupDynamic()
    }
    
    func setupDynamic(){
        self.font = .preferredFont(forTextStyle: .body)
        self.adjustsFontForContentSizeCategory = true
    }

}
