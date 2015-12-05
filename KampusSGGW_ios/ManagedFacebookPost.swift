//
//  FacebookPost.swift
//  KampusSGGW
//
//  Created by Pawel Sygnowski on 07/11/15.
//  Copyright © 2015 QexT. All rights reserved.
//

import UIKit
import CoreData

class ManagedFacebookPost: NSManagedObject{
    @NSManaged var pageId: String?
    @NSManaged var postId: String?
    @NSManaged var objectId: String?
    @NSManaged var message: String
    @NSManaged var picture: String
    
    class func createInManagedObjectContext(context: NSManagedObjectContext) -> ManagedFacebookPost{
        let post = NSEntityDescription.insertNewObjectForEntityForName("ManagedFacebookPost", inManagedObjectContext: context) as! ManagedFacebookPost
        return post
    }
}
