//
//  Link.swift
//  KampusSGGW
//
//  Created by Pawel Sygnowski on 04/11/15.
//  Copyright © 2015 QexT. All rights reserved.
//

import UIKit

class Link: NSObject {
    var title: String
    var picture: UIImage?
    var url: String
    var facebookId: String?
    
    init(title: String, picture: String, url: String, facebookId: String?){
        self.title = title
        self.picture = UIImage(named: picture)
        self.url = url
    }
}


extension Link{
    class func open(url: String, facebookId: String?){
        let fbURLWeb = NSURL(string: url)!
        
        guard facebookId != nil else{
            UIApplication.sharedApplication().openURL(fbURLWeb)
            return
        }
        
        let fbURLApp = NSURL(string: "fb://profile/\(facebookId)")!
        
        if(UIApplication.sharedApplication().canOpenURL(fbURLApp)){
            UIApplication.sharedApplication().openURL(fbURLApp)
        }
        else{
            UIApplication.sharedApplication().openURL(fbURLWeb)
        }
    }
    
    class func fromJSON(json: NSDictionary) -> Link?{
        let title = json["title"] as? String
        let picture = json["picture"] as? String
        let url = json["url"] as? String
        let facebookId = json["facebookId"] as? String
        
        guard title != nil || picture != nil || url != nil else{
            print("parse error", json)
            return nil
        }
        
        return Link(title: title!, picture: picture!, url: url!, facebookId: facebookId)
    }
}