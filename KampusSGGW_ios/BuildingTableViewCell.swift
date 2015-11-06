//
//  BuildingTableViewCell.swift
//  KampusSGGW_ios
//
//  Created by Pawel Sygnowski on 30/09/15.
//  Copyright © 2015 QexT. All rights reserved.
//

import UIKit

class BuildingTableViewCell: UITableViewCell {
    @IBOutlet weak var building: UILabel?
    @IBOutlet weak var departments: UILabel?
}

extension BuildingTableViewCell{
    func assignValuesFromBuilding(building: Building){
        self.building?.text = building.name
        self.departments?.text = building.departments
    }
}
