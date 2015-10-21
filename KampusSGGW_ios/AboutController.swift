//
//  AboutController.swift
//  KampusSGGW_ios
//
//  Created by Pawel Sygnowski on 11/10/15.
//  Copyright © 2015 QexT. All rights reserved.
//

import UIKit

class AboutController: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var contentView: UIView!
    
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
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
