//
//  Building.swift
//  KampusSGGW_ios
//
//  Created by Pawel Sygnowski on 29/09/15.
//  Copyright © 2015 QexT. All rights reserved.
//

import UIKit
import MapKit

class Building: NSObject, MKAnnotation {
    let name: String
    let coordinate: CLLocationCoordinate2D
    
    init(name: String, latitude: CLLocationDegrees, longitude: CLLocationDegrees){
        self.name = name
        self.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        super.init()
    }
    
    var title: String?{
        return self.name
    }
    
    class func fromJSON(json: NSDictionary) -> Building?{
        let name = json["name"] as? String
        var longitude: Double?
        var latitude: Double?
        if let position = json["position"] as? NSDictionary{
            if let positionLongitude = position["longitude"] as? NSString{
                longitude = positionLongitude.doubleValue
            }
            if let positionLatitude = position["latitude"] as? NSString{
                latitude = positionLatitude.doubleValue
            }
        }
        
        if name != nil && longitude != nil && latitude != nil{
            return Building(name: name!, latitude: latitude!, longitude: longitude!)
        }
        return nil
    }
}
