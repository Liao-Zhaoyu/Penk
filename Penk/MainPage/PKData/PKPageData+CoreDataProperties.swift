//
//  PKPageData+CoreDataProperties.swift
//  Penk
//
//  Created by lzy-os on 16/6/1.
//  Copyright © 2016年 lzy-os. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension PKPageData {

    @NSManaged var pageid: NSNumber?
    @NSManaged var bookid: NSNumber?
    @NSManaged var doodle: NSData?
    @NSManaged var text: String?
    @NSManaged var groupid: NSNumber?
    @NSManaged var name: String?

}
