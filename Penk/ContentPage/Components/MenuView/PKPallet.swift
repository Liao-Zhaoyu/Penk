//
//  PKPallet.swift
//  Penk
//
//  Created by Yunhao on 16/5/30.
//  Copyright © 2016年 Yunhao. All rights reserved.
//

import UIKit
import Material
import GoogleMaterialDesignIcons

class PKPallet: PKMenuView {
    
    init() {
        super.init()
        
        // Initialize the menu and setup the configuration options.
        menu.direction = .Down
        menu.views = [
            PKFabButton(googleIcon: GoogleIcon.eae8),
            PKFabButton(backgroundColor: PKaRGB(hex: 0xFFd50000).toUIColor),
            PKFabButton(backgroundColor: PKaRGB(hex: 0xFFF4511E).toUIColor),
            PKFabButton(backgroundColor: PKaRGB(hex: 0xFFF50057).toUIColor),
            PKFabButton(backgroundColor: PKaRGB(hex: 0xFF03A9F4).toUIColor),
            PKFabButton(backgroundColor: PKaRGB(hex: 0xFF4CAF50).toUIColor),
            PKFabButton(backgroundColor: PKaRGB(hex: 0xFFFFEB3B).toUIColor),
            PKFabButton(backgroundColor: PKaRGB(hex: 0xFF000000).toUIColor)
        ]
        
        for btn in menu.views! {
            if btn === menu.views?.first {
                (btn as! PKFabButton).addTarget(self, action: #selector(handleMenu), forControlEvents: .TouchUpInside)
            } else {
                (btn as! PKFabButton).addTarget(self, action: #selector(handleButton), forControlEvents: .TouchUpInside)
            }
            addSubview(btn)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    internal func palletColor(button: UIButton) -> UIColor {
        return (button as! PKFabButton).backgroundColor!
    }
    
}
