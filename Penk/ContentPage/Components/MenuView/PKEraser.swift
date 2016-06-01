//
//  PKEraser.swift
//  Penk
//
//  Created by Yunhao on 16/5/30.
//  Copyright © 2016年 Yunhao. All rights reserved.
//

//
//  PKEraser.swift
//  Penk
//
//  Created by Yunhao on 16/5/30.
//  Copyright © 2016年 Yunhao. All rights reserved.
//
import UIKit
import Material
import GoogleMaterialDesignIcons

class PKEraser: PKMenuView {
    
    init() {
        super.init()
        
        // Initialize the menu and setup the configuration options.
        menu.direction = .Down
        menu.views = [
            PKFabButton(googleIcon: GoogleIcon.ea56),
            PKFabButton(googleIcon: GoogleIcon.e82e, customTag: "0.1"),
            PKFabButton(googleIcon: GoogleIcon.e82e, customTag: "0.3"),
            PKFabButton(googleIcon: GoogleIcon.e82e, customTag: "0.5"),
            PKFabButton(googleIcon: GoogleIcon.e82e, customTag: "0.8")
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
    
    internal func eraserSize(button: UIButton) -> CGFloat {
        return (button as! PKFabButton).customTag.CGFloatValue
    }
}



