//
//  HomeViewController.swift
//  Penk
//
//  Created by lzy-os on 16/6/1.
//  Copyright © 2016年 lzy-os. All rights reserved.
//

import UIKit
import CoreData

class HomeController: UIViewController,UIScrollViewDelegate {

    let size = UIScreen.mainScreen().bounds.size
    var scrollView:PKBookScrollView?
    var navigationBar:PKBookNavigationBar?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
//        print(NSHomeDirectory())
        prepareScrollView()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        prepareNavigationBar()
    }
    
    func prepareScrollView(){
        scrollView = PKBookScrollView(frame: CGRectMake(0, 50, size.width, size.height))
        self.view.addSubview(self.scrollView!)
        self.scrollView?.delegate = self
    }
    
    func prepareNavigationBar(){
        navigationBar = PKBookNavigationBar(frame: CGRectMake(0,0,size.width,50))
        self.view.addSubview(navigationBar!)
    }
    
    func refreshScollView(){
        self.scrollView?.removeFromSuperview()
        let type = scrollView?.displaytype!
        self.scrollView = PKBookScrollView(frame: CGRectMake(0, 50, size.width, size.height), type: type!)
        self.view.addSubview(self.scrollView!)
    }
    
    func changeScollView(){
        self.scrollView?.removeFromSuperview()
        let type = !((scrollView?.displaytype)!)
        self.scrollView = PKBookScrollView(frame: CGRectMake(0, 50, size.width, size.height),type: type)
        self.view.addSubview(self.scrollView!)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
