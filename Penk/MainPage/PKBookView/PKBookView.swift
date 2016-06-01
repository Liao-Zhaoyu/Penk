//
//  PKBook.swift
//  book
//
//  Created by lzy-os on 16/5/30.
//  Copyright © 2016年 lzy-os. All rights reserved.
//

import UIKit
import CoreData

class PKBook: UIView{
    
    
    var bookView = UIView?()
    var label = UILabel?()
    var img = UIImage?()
    var bookdata = NSManagedObject?()
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let height = frame.size.height
        let width = frame.size.width
        
        bookView = UIView(frame: CGRectMake(0,0,width,height))
        bookView?.backgroundColor = UIColor.brownColor()
        label = UILabel(frame: CGRectMake(0,0,width,height/8))
        label?.backgroundColor = UIColor.blackColor()
        label?.textColor = UIColor.whiteColor()
        label?.textAlignment = .Center
        bookView?.addSubview(label!)
        self.addSubview(bookView!)
    }
    
    func prepareData(data:NSManagedObject) {
        bookdata = data
        label?.text = bookdata?.valueForKey("name") as? String
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?){
        print("touch")
        print(bookdata?.valueForKey("bookid"))
        
        
    }
    
    func setPageController(){
        
    }
    
    
}
