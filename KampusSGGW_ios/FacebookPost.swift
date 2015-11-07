//
//  FacebookPost.swift
//  KampusSGGW
//
//  Created by Pawel Sygnowski on 07/11/15.
//  Copyright © 2015 QexT. All rights reserved.
//

import UIKit

class FacebookPost{
    var pageId: String?
    var postId: String?
    var objectId: String?
    var message: String
    var picture: String
    
    init(id:String, message: String, picture: String, objectId: String?){
        var ids = id.characters.split{ $0 == "_" }.map(String.init)
        if ids.count == 2{
            self.pageId = ids[0]
            self.postId = ids[1]
        }
        self.message = message
        self.picture = picture
        self.objectId = objectId
    }
    
    func open(){
        let fbURLWeb = NSURL(string: "https://www.facebook.com/\(self.pageId!)/posts/\(self.postId!)")!
        UIApplication.sharedApplication().openURL(fbURLWeb)
    }
}
