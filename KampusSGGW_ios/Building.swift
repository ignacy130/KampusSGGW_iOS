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
    let departments: String
    let departmentsArray: [String]
    let searchText: String
    let coordinate: CLLocationCoordinate2D
    let location: CLLocation
    var pin: UIImage
    var activePin: UIImage
    
    init(id: String, name: String, departments: String, latitude: CLLocationDegrees, longitude: CLLocationDegrees, pin: String, active: String?){
        self.id = id
        self.name = name
        self.departments = departments
        self.departmentsArray = departments.componentsSeparatedByString(", ")
        let firstLetters = departments.componentsSeparatedByString(" ").filter{ $0.characters.count > 1 }.map{ String($0.characters.first!) }.joinWithSeparator("")
        self.searchText = (name + departments + firstLetters).lowercaseString
        self.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        self.location = CLLocation(latitude: latitude, longitude: longitude)
        self.pin = Building.createPin(id, image: pin)

        if active != nil{
            self.activePin = Building.createPin(id, image: active!)
        }
        else{
            self.activePin = self.pin
        }
        
        super.init()
    }
    
    var title: String?{
        return self.name
    }
    
    var subtitle: String?{
        return self.departments
    }
}

//Static

extension Building{
    class func fromJSON(json: NSDictionary) -> Building?{
        let id = json["id"] as? String
        let name = json["name"] as? String
        let pin = json["pin"] as? String
        let activePin = json["pin-active"] as? String
        var departments: String?
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
        if let descriptions = json["descriptions"] as? NSDictionary{
            if let department = descriptions["text"] as? String{
                departments = department
            }
            if let deparmentsArray = descriptions["text"] as? [String]{
                departments = deparmentsArray.joinWithSeparator(", ")
            }
        }
        
        if id != nil && name != nil && longitude != nil && latitude != nil && departments != nil && pin != nil{
            return Building(id: id!, name: name!, departments: departments!, latitude: latitude!, longitude: longitude!, pin: pin!, active: activePin)
        }
        else{
            print("Parse failed", json)
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
        
        UIGraphicsBeginImageContext(image.size)
        
        image.drawInRect(CGRectMake(0, 0, image.size.width, image.size.height))
        
        let rect = CGRectMake(0, image.size.width/4, image.size.width, image.size.height)
        text.drawInRect(rect, withAttributes: attributes)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
        
    }
}
