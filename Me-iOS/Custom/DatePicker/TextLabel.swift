//
//  TextLabel.swift
//  Me-iOS
//
//  Created by Development Kingdom on 18.09.2020
//  Copyright © 2020 Tcacenco Daniel. All rights reserved.
//

import UIKit

class TextLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(Text: String) {
        self.init(frame: .zero)
        self.text = Text
        self.textColor = .white
        self.textAlignment = .center
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
