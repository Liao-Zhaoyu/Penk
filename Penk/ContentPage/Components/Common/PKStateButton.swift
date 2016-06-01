//
//  PKStateButton.swift
//  Penk
//
//  Created by Yunhao on 16/6/1.
//  Copyright © 2016年 Yunhao. All rights reserved.
//

import UIKit
import Material
import GoogleMaterialDesignIcons

protocol PKStateButtonDelegate {
    func stateButtonToggleTo(button: UIButton, state: Bool)
}

class PKStateButton: PKFabButton {
    
    var opened:Bool {
        return toggle
    }
    
    /// 是否开/关 true/false
    private var toggle:Bool = false
    
    var stateButtonDelegate:PKStateButtonDelegate?
    
    override init( googleIcon: String? = nil,textColor:UIColor? = nil, diameter: CGFloat? = nil, backgroundColor: UIColor? = nil, depth: MaterialDepth? = nil, customTag: String? = nil) {
        super.init(googleIcon: googleIcon, textColor: textColor, diameter: diameter, backgroundColor: backgroundColor, depth: depth, customTag: customTag)
        addTarget(self, action: #selector(stateButtonTap), forControlEvents: .TouchUpInside)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    internal func turnStateButtonTo(state: Bool) {
        if state {
            (self as MaterialButton).animate(MaterialAnimation.rotate(rotation: 0.125))
        } else {
            (self as MaterialButton).animate(MaterialAnimation.rotate(rotation: 0))
        }
        toggle = state
    }
    
    func stateButtonTap() {
        stateButtonDelegate?.stateButtonToggleTo(self, state: !toggle)
    }
    
}
