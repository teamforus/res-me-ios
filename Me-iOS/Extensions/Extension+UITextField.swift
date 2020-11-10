//
//  Extension+UITextField.swift
//  Me-iOS
//
//  Created by Tcacenco Daniel on 04.08.20.
//  Copyright © 2020 Tcacenco Daniel. All rights reserved.
//

import UIKit

extension UITextField {

    func setPlaceholderColor(with text: String, and color: UIColor) {
        self.attributedPlaceholder =
        NSAttributedString(string: text, attributes: [NSAttributedString.Key.foregroundColor: color])
    }
}

