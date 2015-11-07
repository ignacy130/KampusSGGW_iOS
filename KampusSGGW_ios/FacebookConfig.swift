//
//  FacebookConfig.swift
//  KampusSGGW
//
//  Created by Pawel Sygnowski on 07/11/15.
//  Copyright © 2015 QexT. All rights reserved.
//

import UIKit

class FacebookConfig{
    init(id: String, secret: String){
        self.clientId = id
        self.clientSecret = secret
    }
    
    var clientId: String
    var clientSecret: String
    
    class func getDefault() -> FacebookConfig{
        return FacebookConfig(id: "837519593012071", secret: "07fd8d5b088b5f04ea2da9d94a7ca72e")
    }
}
