//
//  FacebookPosts.swift
//  KampusSGGW
//
//  Created by Pawel Sygnowski on 05/12/15.
//  Copyright © 2015 QexT. All rights reserved.
//

import UIKit
import CoreData

class FacebookPosts: NSObject {
    private static var _instance : FacebookPosts?;
    
    static func getInstance() -> FacebookPosts{
        if _instance == nil{
            _instance = FacebookPosts()
        }

        return _instance!
    }
    
    let managedContext: NSManagedObjectContext
    
    override init(){
        managedContext = AppDelegate().managedObjectContext!
        super.init()
    }
    
    func save(pageId: String, posts: [FacebookPost]){
        clear(pageId)
        
        for post in posts{
            let entity = NSEntityDescription.entityForName("ManagedFacebookPost",
                inManagedObjectContext: managedContext)
            
            let options = NSManagedObject(entity: entity!,
                insertIntoManagedObjectContext:managedContext)
            
            options.setValue(post.pageId, forKey: "pageId")
            options.setValue(post.postId, forKey: "postId")
            options.setValue(post.picture, forKey: "picture")
            options.setValue(post.objectId, forKey: "objectId")
            options.setValue(post.message, forKey: "message")
        }
        
        do{
            try managedContext.save()
        }
        catch let error as NSError{
            print(error.localizedDescription)
        }

    }
    
    func load(pageId: String) -> [FacebookPost]{
        var posts = [FacebookPost]()
        let request = NSFetchRequest(entityName: "ManagedFacebookPost")
        let predicate = NSPredicate(format: "pageId == %@", pageId)
        request.predicate = predicate
        do{
            let fetchedResults = try managedContext.executeFetchRequest(request) as? [ManagedFacebookPost]
            
            if let results = fetchedResults{
                for post in results{
                    posts.append(FacebookPost(pageId: post.pageId!, postId: post.postId!, message: post.message, picture: post.picture, objectId: post.objectId))
                }
            }
        }
        catch let fetchError as NSError{
            print(fetchError.localizedDescription)
        }
        return posts
    }
    
    func clear(pageId: String){
        clearEntity(pageId, entity: String(ManagedFacebookPost))
    }
    
    func clearEntity(pageId: String, entity: String){
        let request = NSFetchRequest(entityName: entity)
        let predicate = NSPredicate(format: "pageId == %@", pageId)
        request.predicate = predicate
        
        do{
            let fetchedResults = try managedContext.executeFetchRequest(request) as? [NSManagedObject]
            if let results = fetchedResults{
                for result in results{
                    managedContext.deleteObject(result);
                }
            }
            try managedContext.save();
        }
        catch let fetchError as NSError{
            print(fetchError.localizedDescription)
        }
    }
    
    func shouldRefresh(pageId: String) -> Bool {
        let request = NSFetchRequest(entityName: "ManagedFacebookPostRefresh")
        let predicate = NSPredicate(format: "pageId == %@", pageId)
        request.predicate = predicate
        do{
            let fetchedResults = try managedContext.executeFetchRequest(request) as? [ManagedFacebookPostRefresh]
            
            guard fetchedResults?.count > 0 else{
                return true
            }
            
            let lastRefreshDate = fetchedResults![0].date;
            if lastRefreshDate.isLessThanDate(NSDate().yesterday()){
                return false
            }
            
        }
        catch let fetchError as NSError{
            print(fetchError.localizedDescription)
        }
        return true;
    }
    
    func clearRefresh(pageId: String){
        clearEntity(pageId, entity: String(ManagedFacebookPostRefresh))
    }
    
    func markRefresh(pageId: String){
        clearRefresh(pageId)
        
        let entity = NSEntityDescription.entityForName("ManagedFacebookPostRefresh",
            inManagedObjectContext: managedContext)
        
        let options = NSManagedObject(entity: entity!,
            insertIntoManagedObjectContext:managedContext)
        
        options.setValue(pageId, forKey: "pageId")
        options.setValue(NSDate(), forKey: "date")
        
        do{
            try managedContext.save()
        }
        catch let error as NSError{
            print(error.localizedDescription)
        }
    }
}
