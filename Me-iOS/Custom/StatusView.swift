//
//  StatusView.swift
//  Me
//
//  Created by Tcacenco Daniel on 8/15/18.
//  Copyright © 2018 Foundation Forus. All rights reserved.
//

import UIKit

class StatusView: Background_DarkMode {

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        var frameView: CGRect = self.frame
        if UIScreen.main.nativeBounds.height == 2436 {
            frameView.size.height = 33
        }else{
            frameView.size.height = 17
        }
        self.frame = frameView
    }

}
