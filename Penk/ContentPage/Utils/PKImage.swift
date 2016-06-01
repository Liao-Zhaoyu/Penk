//
//  PKImage.swift
//  Penk
//
//  Created by Yunhao on 16/5/29.
//  Copyright © 2016年 Yunhao. All rights reserved.
//

import UIKit

class PKImage {
    // UIImage
    var imageRaw:UIImage!
    var imageResult:UIImage!
    //CGImage
    var CGImageRaw:CGImage!
    var CGImageResult:CGImage?
    // other
    var colorSpace:CGColorSpace!
    var width:Int!
    var height:Int!
    var bytesPerPixel:Int!
    var bitsPerComponent:Int!
    var bytesPerRow:Int!
    var bitmapInfo:UInt32!
    
    init(){
        
    }
    
    init(image:UIImage){
        self.setRawImage(image)

    }
    
    func setRawImage(image:UIImage) {
        imageRaw = scaleImage(image, scaledToWidth: CGFloat(1024))
        CGImageRaw     = imageRaw.CGImage
        colorSpace       = CGColorSpaceCreateDeviceRGB()
        width            = CGImageGetWidth(CGImageRaw)
        height           = CGImageGetHeight(CGImageRaw)
        bytesPerPixel    = CGImageGetBitsPerPixel(CGImageRaw) / 8
        bitsPerComponent = CGImageGetBitsPerComponent(CGImageRaw)
        bytesPerRow      = bytesPerPixel * width
        bitmapInfo       = CGImageAlphaInfo.PremultipliedFirst.rawValue | CGBitmapInfo.ByteOrder32Little.rawValue
        
    }
    
    //图片等比例压缩
    func scaleImage(image:UIImage,scaledToWidth width:CGFloat)->UIImage
    {
        
        let height = width / image.width * image.size.height
        let sizeImageSmall = CGSizeMake(width, height)
        
        UIGraphicsBeginImageContext(sizeImageSmall);
        image.drawInRect(CGRectMake(0,0,sizeImageSmall.width,sizeImageSmall.height))
        let newImage:UIImage=UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return newImage;
    }
    
    /**
     * 二值化
     *
     * divider 分割点 可传16进制，如： 0xFFFFFF
     *
     */
    internal func colorDivide(divider:UInt32) {
        
        // 获取上下文对象
        let context = CGBitmapContextCreate(nil, width, height, bitsPerComponent, bytesPerRow, colorSpace, bitmapInfo)!
        
        CGContextDrawImage(context, CGRectMake(0, 0, CGFloat(width), CGFloat(height)), CGImageRaw)
        
        // origin_pointer 获取数据指针
        let op = UnsafeMutablePointer<UInt32>(CGBitmapContextGetData(context))

        // current_pointer 当前指针
        var cp = op
        
        for _ in 0..<height {
            for _ in 0...width {
                if UInt32(cp.memory) > divider {
                    cp.memory = PKaRGB.clearBytes()
                }
                cp += 1
            }
        }
        CGImageResult = CGBitmapContextCreateImage(context)
        imageResult = UIImage(CGImage: CGImageResult!, scale: imageRaw.scale/2, orientation: imageRaw.imageOrientation)

    }
    
    
    

}
