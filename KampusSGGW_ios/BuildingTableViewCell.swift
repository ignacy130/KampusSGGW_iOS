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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension BuildingTableViewCell{
    func assignValuesFromBuilding(building: Building){
        self.building?.text = building.name
        self.departments?.text = building.departments
    }
}
