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
        let objects = Json.getObjectsFromFile("Buildings");
        
        var buildings = [Building]()
        for object in objects{
            if let building = Building.fromJSON(object){
                buildings.append(building)
            }

        }
        return buildings
    }
}
