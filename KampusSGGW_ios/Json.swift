//
//  Json.swift
//  KampusSGGW
//
//  Created by Pawel Sygnowski on 04/11/15.
//  Copyright © 2015 QexT. All rights reserved.
//

import UIKit

class Json: NSObject {
    class func getObjectsFromFile(file: String) -> [NSDictionary]{
        var toReturn = [NSDictionary]()
        let file = NSBundle.mainBundle().pathForResource(file, ofType: "json")
        if let content = NSData(contentsOfFile: file!){
            do{
                let json = try NSJSONSerialization.JSONObjectWithData(content, options: .MutableContainers)
                
                if let buildings = json as? NSArray{
                    for building in buildings{
                        if let values = building as? NSDictionary{
                            toReturn.append(values)
                        }
                    }
                }
            }
            catch let error as NSError{
                print(error)
            }
        }
        return toReturn
    }
}
