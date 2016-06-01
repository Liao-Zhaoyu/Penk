//
//  PKMenuView.swift
//  Penk
//
//  Created by Yunhao on 16/5/31.
//  Copyright © 2016年 Yunhao. All rights reserved.
//

import UIKit
import Material
import GoogleMaterialDesignIcons

protocol PKMenuViewDelegate {
    func menuViewHandleMenu(menu:Menu)
    func menuViewHandleButton(button:UIButton)
    func menuViewDidTapOutside(menuView:PKMenuView)
}

class PKMenuView: MenuView {

    /// 菜单按钮默认直径
    private var _menuDiameter = CGFloat(36)
    
    /// 子按钮默认直径
    private var _buttonDIameter = CGFloat(54)
    
    /// 默认按钮间距
    private var _spacing = CGFloat(10)
    
    // 按钮组 第一个为主按钮
    var buttons:[UIView] {
        return menu.views!
    }
    
    var dia: CGFloat {
        return _menuDiameter
    }
    
    // 委托
    var menuViewDelegate: PKMenuViewDelegate?
    
    
    /// - parameter menuDiameter 菜单按钮直径
    /// - parameter buttonDiameter 子按钮直径
    init(menuDiameter: CGFloat? = nil, buttonDiameter: CGFloat? = nil,spacing: CGFloat? = nil) {
        super.init(frame: CGRectZero)

        if menuDiameter != nil { _menuDiameter = menuDiameter! }
        if buttonDiameter != nil { _buttonDIameter = buttonDiameter! }
        if spacing != nil {
            _spacing = spacing!
        }
        menu.baseSize = CGSize(width: _menuDiameter, height: _menuDiameter)
        menu.spacing = _spacing
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func handleMenu() {
        #if DEBUG
            NSLog("handleMenu: menu is pressed. \(self)")
        #endif
        
        if menuViewDelegate != nil {
            menuViewDelegate?.menuViewHandleMenu(menu)
        }
    }
    
    func handleButton(button:UIButton) {
        #if DEBUG
            NSLog("handleButton: button is pressed. \(self)")
        #endif
        
        if menuViewDelegate != nil {
            menuViewDelegate?.menuViewHandleButton(button)
        }
    }
    
    override func hitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView? {
        
        //在菜单打开时，检测是否点击了菜单view之外的区域
        guard !hidden else {
            return nil
        }
        
        for v in subviews {
            let p: CGPoint = v.convertPoint(point, fromView: self)
            if CGRectContainsPoint(v.bounds, p) {
                return v.hitTest(p, withEvent: event)
            }
        }
        
        if menu.opened && menuViewDelegate != nil {
            #if DEBUG
                NSLog("hitTest: menu view is tapped outside. \(self)")
            #endif
            menuViewDelegate?.menuViewDidTapOutside(self)
        }
        return super.hitTest(point, withEvent: event)
    }

    /// 返回true 如果当前menuView包含指定button
    internal func contains(button:UIButton) -> Bool {
        if let v = menu.views {
            return v.contains(button)
        } else {
            return false
        }
    }
    
}
