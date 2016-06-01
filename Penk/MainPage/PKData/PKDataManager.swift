//
//  PKData.swift
//  book
//
//  Created by lzy-os on 16/5/30.
//  Copyright © 2016年 lzy-os. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class PKDataManager {
    
    var context:NSManagedObjectContext!
    var maxData:PKMaxData!
    
    init(){
        context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        initMaxData()
    }
    
    /// 初始化当前最大id
    func initMaxData(){
        let dataArr:Array<AnyObject> = self.getData("PKMaxData")
        if(dataArr.count == 0){
            let row:AnyObject = NSEntityDescription.insertNewObjectForEntityForName("PKMaxData", inManagedObjectContext: context)
            row.setValue(0, forKey: "maxbookid")
            row.setValue(0, forKey: "maxpageid")
            row.setValue(0, forKey: "maxgroupid")
            try! context.save()
        }
        else{
            maxData = getData("PKMaxData").first as! PKMaxData
        }
    }
    
    /// id+1
    func refreshMaxBookid(){
        maxData.setValue((maxData.valueForKey("maxbookid") as! Int)+1, forKey: "maxbookid")
    }
    func refreshMaxPageid(){
        maxData.setValue((maxData.valueForKey("maxpageid") as! Int)+1, forKey: "maxpageid")
    }
    func refreshMaxGroupid(){
        maxData.setValue((maxData.valueForKey("maxgroupid") as! Int)+1, forKey: "maxgroupid")
    }
    
    /// 以表名获取数据库数据
    func getData(entityName:String) ->Array<AnyObject>{
        var dataArr:Array<AnyObject> = []
        let fetch = NSFetchRequest(entityName: "\(entityName)")
        try! dataArr = context.executeFetchRequest(fetch)
        return dataArr
    }
    
    /// 以名字创建新书
    func createNewBook(name:String) {
        let row:AnyObject = NSEntityDescription.insertNewObjectForEntityForName("PKBookData", inManagedObjectContext: context)
        let imgData = NSData()
        
        row.setValue(name, forKey: "name")
        row.setValue(imgData, forKey: "cover")
        row.setValue(self.maxData.valueForKey("maxbookid"), forKey: "bookid")
        self.refreshMaxBookid()
        
        try! context.save()
    }
    
    /// 以名字和封面创建新书
    func createNewBook(name:String, image:UIImage) {
        let row:AnyObject = NSEntityDescription.insertNewObjectForEntityForName("PKBookData", inManagedObjectContext: context)
        let imgData = UIImagePNGRepresentation(image)
        
        row.setValue(name, forKey: "name")
        row.setValue(imgData, forKey: "cover")
        row.setValue(self.maxData.valueForKey("maxbookid"), forKey: "bookid")
        self.refreshMaxBookid()
        
        try! context.save()
    }
    
    /// 删除书本
    func deleteBook(book:NSManagedObject){
        var dataArr:Array<AnyObject> = self.getData("PKPageData")
        for i in 0..<dataArr.count{
            let data = dataArr[i] as! NSManagedObject
            if((data.valueForKey("bookid") as! Int) == (book.valueForKey("bookid") as! Int)){
                self.deletePage(data)
            }
        }
        context.deleteObject(book)
        try! context.save()
    }
    
    /// 编辑书本名
    func editBookName(newName:String, book:NSManagedObject){
        book.setValue(newName, forKey: "name")
        try! context.save()
    }
    
    /// 以名字创建笔记页
    func createNewPage(name:String, book:NSManagedObject) {
        let text = ""
        let imagedata = NSData()
        let groupid = 0
        let row:AnyObject = NSEntityDescription.insertNewObjectForEntityForName("PKPageData", inManagedObjectContext: context)
        
        row.setValue(name, forKey: "name")
        row.setValue(book.valueForKey("bookid") as! Int, forKey: "bookid")
        row.setValue(text, forKey: "text")
        row.setValue(imagedata, forKey: "doodle")
        row.setValue(groupid, forKey: "group")
        row.setValue(maxData.valueForKey("maxpageid"), forKey: "pageid")
        self.refreshMaxPageid()
        
        try! context.save()
    }
    
    /// 删除笔记页
    func deletePage(page:NSManagedObject){
        context.deleteObject(page)
        try! context.save()
    }
    
    /// 编辑笔记页内容（无插入图片)
    func editPageContent(text:String, image:UIImage, page:NSManagedObject){
        let imagedata = UIImagePNGRepresentation(image)
        page.setValue(text, forKey: "text")
        page.setValue(imagedata, forKey: "doodle")
        try! context.save()
    }
    
    /// 编辑笔记页名字
    func editPageName(newName:String, page:NSManagedObject){
        page.setValue(newName, forKey: "name")
        try! context.save()
    }
    
    /// 获取笔记页文本
    func getPageContentText(page:NSManagedObject) ->String{
        return page.valueForKey("text") as! String
    }
    
    /// 获取笔记页涂鸦
    func getPageContentImg(page:NSManagedObject) ->UIImage{
        return UIImage(data: (page.valueForKey("doodle") as! NSData))!
    }
    
}

    
    
    
