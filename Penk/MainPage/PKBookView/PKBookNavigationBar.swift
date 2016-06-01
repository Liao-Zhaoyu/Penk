//
//  PKBookNavigationBar.swift
//  Penk
//
//  Created by lzy-os on 16/6/1.
//  Copyright © 2016年 lzy-os. All rights reserved.
//

import UIKit

class PKBookNavigationBar: UINavigationBar {

    var navigationItem: UINavigationItem!
    var nextbook:HomeController?
    
    override init(frame: CGRect) {
        // 1
        super.init(frame: frame)
        navigationItem = UINavigationItem(title: "Home")
        // 2
        self.barStyle = UIBarStyle.Black
        self.tintColor = UIColor.yellowColor()
        // 3
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        imageView.contentMode = .ScaleAspectFit
  
        let leftBtn = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Bookmarks,
                                      target: self, action: #selector(PKBookNavigationBar.displayType))
        //创建右边按钮
        let rightBtn = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add,
                                       target: self, action: #selector(PKBookNavigationBar.addBook))
        //设置导航项左边的按钮
        navigationItem.setLeftBarButtonItem(leftBtn, animated: true)
        //设置导航项右边的按钮
        navigationItem.setRightBarButtonItem(rightBtn, animated: true)
        //添加导航栏item
        self.pushNavigationItem(navigationItem, animated: true)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func displayType(){
        let vc = UIApplication.sharedApplication().keyWindow?.rootViewController as! HomeController
        vc.changeScollView()
    }
    
 
    func addBook(){
        print("addBook")
        let pkdata = PKDataManager()
        let vc = UIApplication.sharedApplication().keyWindow?.rootViewController as! HomeController
        //数据库操作，增加笔记本
        
        vc.refreshScollView()
        
        //old.reloadInputViews()
        
    }
}
