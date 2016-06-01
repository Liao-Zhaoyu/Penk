//
//  PKPixel.swift
//  Penk
//
//  Created by Yunhao on 16/5/29.
//  Copyright © 2016年 Yunhao. All rights reserved.
//

import UIKit

class PKPixel {
    
    var aRGB:PKaRGB!
    
    /// 返回bytes
    var bytes:UInt32 {
        get {
            return (UInt32(aRGB.a) << 24) | (UInt32(aRGB.R) << 16) | (UInt32(aRGB.G) << 8) | (UInt32(aRGB.B) << 0)
        }
    }
    
    init(aRGB:PKaRGB){
        self.aRGB = aRGB
    }

    
}

class PKaRGB {
    internal var a:UInt8!
    internal var R:UInt8!
    internal var G:UInt8!
    internal var B:UInt8!
    
    /// 使用 Int32 或 8位16进制数值 初始化
    var bytes:UInt32 {
        get {
            return (UInt32(a) << 24) | (UInt32(R) << 16) | (UInt32(G) << 8) | (UInt32(B) << 0)
        }
    }
    
    var toUIColor:UIColor {
        get {
            return UIColor(red: CGFloat(R)/255,green: CGFloat(G)/255, blue: CGFloat(B)/255, alpha: CGFloat(a)/255)
        }
    }
    
    init(a: UInt8, R: UInt8, G: UInt8, B: UInt8) {
        self.a = a
        self.R = R
        self.G = G
        self.B = B
    }
    
    init(a: Int, R: Int, G: Int, B: Int) {
        self.a = UInt8(a)
        self.R = UInt8(R)
        self.G = UInt8(G)
        self.B = UInt8(B)
    }
    
    /// 使用 Int32 或 8位16进制数值 初始化
    init(hex:UInt32) {
        a = UInt8((hex >> 24) & 255)
        R = UInt8((hex >> 16) & 255)
        G = UInt8((hex >> 8) & 255)
        B = UInt8((hex >> 0) & 255)
    }
    
    /// 透明aRGB值
    static func clear() -> PKaRGB {
        return PKaRGB(a: 0, R: 0, G: 0, B: 0)
    }
    
    /// 透明aRGB bytes值
    static func clearBytes() -> UInt32 {
        return PKaRGB(a: 0, R: 0, G: 0, B: 0).bytes
    }
}
