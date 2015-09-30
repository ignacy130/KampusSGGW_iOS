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
    let id: String
    let name: String
    let coordinate: CLLocationCoordinate2D
    let location: CLLocation
    var pin: UIImage
    var activePin: UIImage
    
    init(id: String, name: String, latitude: CLLocationDegrees, longitude: CLLocationDegrees){
        self.id = id
        self.name = name
        self.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        self.location = CLLocation(latitude: latitude, longitude: longitude)
        self.pin = Building.createPin(id, image: "pin.png")
        self.activePin = Building.createPin(id, image: "active.png")
        
        super.init()
    }
    
    var title: String?{
        return self.name
    }
    
    class func fromJSON(json: NSDictionary) -> Building?{
        let id = json["id"] as? String
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
        
        if id != nil && name != nil && longitude != nil && latitude != nil{
            return Building(id: id!, name: name!, latitude: latitude!, longitude: longitude!)
        }
        return nil
    }
    
    class func createPin(text: String, image: String) -> UIImage{
        let image = UIImage(named: image)!
        let color: UIColor = UIColor.blackColor()
        let font: UIFont = UIFont.boldSystemFontOfSize(12)
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .Center
        
        let attributes = [
            NSFontAttributeName: font,
            NSForegroundColorAttributeName: color,
            NSParagraphStyleAttributeName: paragraph
        ]
        let size = CGSizeMake(24, 34)
        
        UIGraphicsBeginImageContext(size)
        
        image.drawInRect(CGRectMake(0, 0, size.width, size.height))
        
        let rect = CGRectMake(0, 5, size.width, size.height)
        text.drawInRect(rect, withAttributes: attributes)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
        
    }
}
