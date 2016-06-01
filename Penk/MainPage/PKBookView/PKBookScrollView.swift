//
//  PKBookScrollView.swift
//  Penk
//
//  Created by lzy-os on 16/6/1.
//  Copyright © 2016年 lzy-os. All rights reserved.
//

import UIKit
import CoreData

class PKBookScrollView: UIScrollView {

    var size:CGSize!
    var displaytype:Bool!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        size = frame.size
        displaytype = true
        
        var dataArr:Array<AnyObject>!
        let pkdata = PKDataManager()
        dataArr = pkdata.getData("PKBookData")
        
        self.contentOffset = CGPointMake(0, 0)
        
        print(dataArr.count)
        if(displaytype == false){
            tableView(dataArr)
        }else{
            listView(dataArr)
        }
        
    }
    
    init(frame: CGRect,type: Bool) {
        super.init(frame: frame)
        size = frame.size
        displaytype = type
        var dataArr:Array<AnyObject>!
        let pkdata = PKDataManager()
        dataArr = pkdata.getData("PKBookData")
        
        self.contentOffset = CGPointMake(0, 0)
        
        print(dataArr.count)
        if(displaytype == false){
            tableView(dataArr)
        }else{
            listView(dataArr)
        }
        
    }
    
    func tableView(dataArr:Array<AnyObject>){
        self.contentSize = CGSizeMake(size.width, size.height * CGFloat(dataArr.count/5+1))
        let width = size.width/4
        let height = size.width/(3)
        let hor = size.width/6
        
        if(dataArr.count != 0) {
            for var i = 1; i<=dataArr.count; i+=2 {
                
                let ver = size.width/(3)*CGFloat(i)
                if(dataArr.count - i >= 0){
                    let pkbook1 = PKBook(frame: CGRectMake(hor,ver,width,height))
                    pkbook1.prepareData((dataArr[i-1] as? NSManagedObject)!)
                    self.addSubview(pkbook1)
                }
                if(dataArr.count - i >= 1){
                    let pkbook2 = PKBook(frame: CGRectMake(hor*3.5,ver,width,height))
                    pkbook2.prepareData((dataArr[i] as? NSManagedObject)!)
                    self.addSubview(pkbook2)
                }
            }
        }
    }
    
    func listView(dataArr:Array<AnyObject>){
        self.contentSize = CGSizeMake(size.width, size.height * CGFloat(dataArr.count/2+1))
        let width = size.width/2
        let height = size.width/(1.5)
        let hor = size.width/4
        
        if(dataArr.count != 0){
            for var i = 1; i<=dataArr.count; i+=1 {
                let ver = size.width/(2)*CGFloat((i-1)*2)+size.width/(2)
                let pkbook1 = PKBook(frame: CGRectMake(hor,ver,width,height))
                pkbook1.prepareData((dataArr[i-1] as? NSManagedObject)!)
                self.addSubview(pkbook1)
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
