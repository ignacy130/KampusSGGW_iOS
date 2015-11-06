//
//  Links.swift
//  KampusSGGW
//
//  Created by Pawel Sygnowski on 04/11/15.
//  Copyright © 2015 QexT. All rights reserved.
//

import UIKit

class Links: NSObject {
    class func getAll() -> [Link]{
        let objects = Json.getObjectsFromFile("Links")
        
        var links = [Link]()
        for object in objects{
            if let link = Link.fromJSON(object){
                links.append(link)
            }
        }
        return links

    }
}
