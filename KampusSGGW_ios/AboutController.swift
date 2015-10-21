//
//  AboutController.swift
//  KampusSGGW_ios
//
//  Created by Pawel Sygnowski on 11/10/15.
//  Copyright © 2015 QexT. All rights reserved.
//

import UIKit

class AboutController: UIViewController {
    @IBAction func openFacebook(sender: AnyObject) {
        let fbURLWeb = NSURL(string: "https://www.facebook.com/silvernetgroupsggw")!
        let fbURLApp = NSURL(string: "fb://profile/428765197142533")!
        
        if(UIApplication.sharedApplication().canOpenURL(fbURLApp)){
            UIApplication.sharedApplication().openURL(fbURLApp)
        }
        else{
            UIApplication.sharedApplication().openURL(fbURLWeb)
        }
    }
}
