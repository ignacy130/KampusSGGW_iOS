//
//  BuildingController.swift
//  KampusSGGW_ios
//
//  Created by Pawel Sygnowski on 15/10/15.
//  Copyright © 2015 QexT. All rights reserved.
//

import UIKit

class BuildingController: UIViewController {
    var building: Building?
    
    @IBOutlet weak var buildingDepartments: UILabel!
    @IBOutlet weak var buildingName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        assignValuesFromBuilding()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func dismissModal(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func assignValuesFromBuilding(){
        buildingName.text = building?.name
        buildingDepartments.text = building?.departmentsArray.joinWithSeparator("\n")
        buildingDepartments.frame = CGRectMake(20,20,200,800)
        buildingDepartments.sizeToFit()
    }
}
