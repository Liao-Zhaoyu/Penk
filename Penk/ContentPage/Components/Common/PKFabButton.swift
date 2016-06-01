//
//  PKFabButton.swift
//  Penk
//
//  Created by Yunhao on 16/5/31.
//  Copyright © 2016年 Yunhao. All rights reserved.
//

import UIKit
import Material
import GoogleMaterialDesignIcons

class PKFabButton: FabButton {

    // 默认半径
    private var _diameter:CGFloat = 36.0
    
    //默认背景色
    private var _backgroundColor:UIColor = UIColor.whiteColor()
    
    //默认阴影深度
    private var _depth:MaterialDepth = .Depth3
    
    //默认图标颜色
    private var _textColor:UIColor = UIColor.blackColor()
    
    /// 按钮半径
    var diameter:CGFloat {
        set(value) {
            _diameter = value
            self.width = _diameter
            self.titleLabel?.font = self.titleLabel?.font.fontWithSize(value*0.7)
        }
        get {
            return _diameter
        }
    }
    
    var customTag:String = ""
    
    /// 使用 Google Material Design Icon 做为按钮图标
    /// - parameter googleIconID    :   字体id GoogleIcon ID
    /// - parameter diameter        :   [可选] 按钮直径
    /// - parameter backgroundColor :   [可选] 背景颜色
    /// - parameter depth           :   [可选] 按钮阴影深度
    init( googleIcon: String? = nil,textColor:UIColor? = nil, diameter: CGFloat? = nil, backgroundColor: UIColor? = nil, depth: MaterialDepth? = nil, customTag: String? = nil) {
    
        if diameter != nil { _diameter = diameter!}
        if backgroundColor != nil { _backgroundColor = backgroundColor! }
        if depth != nil { _depth = depth! }
        if depth != nil { _textColor = textColor! }
        if customTag != nil { self.customTag = customTag! }
        
        super.init(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: _diameter, height: _diameter)))
        //背景
        self.backgroundColor = _backgroundColor
        //阴影深度
        self.depth = _depth
        //设置图标
        if let icon = googleIcon {
            titleLabel?.font = UIFont(name: GoogleIconName, size: _diameter*0.7)
            titleLabel?.sizeToFit()
            setTitleColor(_textColor, forState: .Normal)
            setTitle(icon, forState: .Normal)
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension String {
    var CGFloatValue: CGFloat {
        return CGFloat((self as NSString).doubleValue)
    }
}
