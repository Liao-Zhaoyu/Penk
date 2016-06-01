//
//  PKBottomBar.swift
//  Penk
//
//  Created by Yunhao on 16/5/30.
//  Copyright © 2016年 Yunhao. All rights reserved.
//

import UIKit
import Material
import GoogleMaterialDesignIcons

class PKBottomBar: Toolbar {
    
    override init(frame: CGRect) {
        super.init(frame: CGRect(x: 0, y: 0, width: frame.width, height: CGFloat(50)))
        backgroundColor = PKConfig.topBarColor
        depth = .Depth3
        userInteractionEnabled = true
    }
    
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: CGFloat(50)))
        backgroundColor = PKConfig.bottomBarColor
        depth = .Depth3
        userInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
