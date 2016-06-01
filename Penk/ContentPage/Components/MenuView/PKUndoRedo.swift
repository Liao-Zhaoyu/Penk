//
//  PKUndoRedo.swift
//  Penk
//
//  Created by Yunhao on 16/6/1.
//  Copyright © 2016年 Yunhao. All rights reserved.
//

import UIKit
import Material
import GoogleMaterialDesignIcons

class PKUndoRedo: PKStateButton {
    
    init(type: PKUndoRedoType) {
        let icon = type == PKUndoRedoType.Undo ? GoogleIcon.e844 : GoogleIcon.e82c
        super.init(googleIcon: icon, diameter : CGFloat(36))
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}

enum PKUndoRedoType {
    case Undo,Redo
}
