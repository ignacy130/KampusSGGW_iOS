//
//  Colors.swift
//  KampusSGGW_ios
//
//  Created by Pawel Sygnowski on 30/09/15.
//  Copyright © 2015 QexT. All rights reserved.
//

import UIKit

class Colors: NSObject {
    static var text = UIColor(hex: 0x471323)
    static var background = UIColor(hex: 0xC7FB4C)
}

extension UIColor{
    convenience init(hex:Int) {
        self.init(red: CGFloat((hex & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((hex & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(hex & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0))
    }
}
