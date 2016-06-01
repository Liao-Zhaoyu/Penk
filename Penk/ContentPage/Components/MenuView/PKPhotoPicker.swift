//
//  PKPhotoPicker.swift
//  Penk
//
//  Created by Yunhao on 16/5/29.
//  Copyright © 2016年 Yunhao. All rights reserved.
//

import UIKit
import Material
import GoogleMaterialDesignIcons

class PKPhotoPicker: PKMenuView {
    
    init(diameter: CGFloat? = nil) {
        super.init(menuDiameter: diameter)
        
        // Initialize the menu and setup the configuration options.
        menu.direction = .Up
        menu.views = [
            PKFabButton(googleIcon: GoogleIcon.eac0),
            PKFabButton(googleIcon: GoogleIcon.ea4a, customTag: PKPhotoPickerbehavior.PhotoLibrary.rawValue),
            PKFabButton(googleIcon: GoogleIcon.ea3e, customTag: PKPhotoPickerbehavior.Camera.rawValue)
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
    
    internal func pencilLineSize(button: UIButton) -> CGFloat {
        return (button as! PKFabButton).customTag.CGFloatValue
    }
    
    internal func photoPickerBehavior(button: UIButton) -> PKPhotoPickerbehavior {
        if (button as! PKFabButton).customTag == PKPhotoPickerbehavior.PhotoLibrary.rawValue {
            return PKPhotoPickerbehavior.PhotoLibrary
        } else
        if (button as! PKFabButton).customTag == PKPhotoPickerbehavior.PhotoLibrary.rawValue {
            return PKPhotoPickerbehavior.Camera
        }
        return PKPhotoPickerbehavior.None
    }
    
}

enum PKPhotoPickerbehavior:String {
    case PhotoLibrary = "photoLibrary", Camera = "camera", None = "none"
}

