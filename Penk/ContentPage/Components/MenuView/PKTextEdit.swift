//
//  PKTextEdit.swift
//  Penk
//
//  Created by Yunhao on 16/5/30.
//  Copyright © 2016年 Yunhao. All rights reserved.
//

import UIKit
import Material
import GoogleMaterialDesignIcons

class PKTextEdit: PKStateButton {
    
    init() {
        super.init(googleIcon: GoogleIcon.e842, diameter : CGFloat(36))
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}


