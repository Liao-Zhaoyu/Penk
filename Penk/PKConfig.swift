//
//  PKConfig.swift
//  Penk
//
//  Created by Yunhao on 16/6/1.
//  Copyright © 2016年 Yunhao. All rights reserved.
//

import UIKit
import Material

class PKConfig {
    static let debug = true
    
    static var topBarColor: UIColor {
        return MaterialColor.blueGrey.darken4
    }
    
    static var bottomBarColor: UIColor {
        return MaterialColor.blueGrey.base
    }
}

class PKDebug {
    static var time: String {
         return NSDateFormatter.localizedStringFromDate(NSDate(), dateStyle: .NoStyle, timeStyle: .MediumStyle)
    }
}