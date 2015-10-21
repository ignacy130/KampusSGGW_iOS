//
//  Buildings.swift
//  KampusSGGW_ios
//
//  Created by Pawel Sygnowski on 29/09/15.
//  Copyright © 2015 QexT. All rights reserved.
//

import UIKit

class Buildings: NSObject {
    class func getAll() -> [Building]{
        var toReturn = [Building]()
        let file = NSBundle.mainBundle().pathForResource("Buildings", ofType: "json")
        if let content = NSData(contentsOfFile: file!){
            do{
                let json = try NSJSONSerialization.JSONObjectWithData(content, options: .MutableContainers)
                
                if let buildings = json as? NSArray{
                    for building in buildings{
                        if let values = building as? NSDictionary{
                            if let object = Building.fromJSON(values){
                                toReturn.append(object)
                            }
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
