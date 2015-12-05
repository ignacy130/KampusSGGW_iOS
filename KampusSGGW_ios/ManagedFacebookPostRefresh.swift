//
//  FacebookPostRefresh.swift
//  KampusSGGW
//
//  Created by Pawel Sygnowski on 05/12/15.
//  Copyright © 2015 QexT. All rights reserved.
//

import UIKit
import CoreData

class ManagedFacebookPostRefresh: NSManagedObject {
    @NSManaged var pageId: String
    @NSManaged var date: NSDate
    
    class func createInManagedObjectContext(context: NSManagedObjectContext) -> ManagedFacebookPostRefresh{
        let post = NSEntityDescription.insertNewObjectForEntityForName("ManagedFacebookPostRefresh", inManagedObjectContext: context) as! ManagedFacebookPostRefresh
        return post
    }
}
