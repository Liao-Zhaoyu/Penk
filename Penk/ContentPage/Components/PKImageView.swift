//
//  PKImageView.swift
//  Penk
//
//  Created by Yunhao on 16/5/29.
//  Copyright © 2016年 Yunhao. All rights reserved.
//

protocol PKImageViewDelegate {
    func imageViewHandleMoving(touches: Set<UITouch>)
}


import UIKit

class PKImageView: UIImageView {
    
    // 委托
    var imageViewDelegate: PKImageViewDelegate?
    

    /**
     *  将imageView适应image尺寸，并且进行宽度为superView宽度scaleTo倍的等比缩放
     *
     *  image 图片                          <br/>
     *  superViewFrame 父亲UIView的frame    <br/>
     *  scaleTo 缩放系数                    <br/>
     */
    
    init(image: UIImage?, superViewFrame:CGRect?, scaleTo:CGFloat) {
        super.init(frame:CGRectZero)
        self.image = image
        //图片缩放模式
        contentMode = .ScaleAspectFit
        //imageView尺寸
        let width = superViewFrame!.width * scaleTo
        let height = width / image!.size.width * (image?.size.height)!
        
        frame = CGRect(x: 0, y: 0, width: width, height: height)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesMoved(touches, withEvent: event)
        if(touches.first?.view == self) {
            if imageViewDelegate != nil {
                imageViewDelegate?.imageViewHandleMoving(touches)
            }
        }
        
    }
    
}
