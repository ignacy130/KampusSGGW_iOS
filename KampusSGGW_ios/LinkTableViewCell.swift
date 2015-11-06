//
//  LinkTableViewCell.swift
//  KampusSGGW
//
//  Created by Pawel Sygnowski on 04/11/15.
//  Copyright © 2015 QexT. All rights reserved.
//

import UIKit

class LinkTableViewCell: UITableViewCell {
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var picture: UIImageView!
}

extension LinkTableViewCell{
    func assignValuesFromLink(link: Link){
        self.title.text = link.title
        if let picture = link.picture{
            self.picture.image = picture
        }
    }
}
