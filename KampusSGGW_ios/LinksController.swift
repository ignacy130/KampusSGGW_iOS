//
//  LinksController.swift
//  KampusSGGW
//
//  Created by Pawel Sygnowski on 04/11/15.
//  Copyright © 2015 QexT. All rights reserved.
//

import UIKit

class LinksController: UITableViewController {
    var links = [Link]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        links = Links.getAll()
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let link = links[indexPath.row]
        Link.open(link.url, facebookId: link.facebookId)
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("linkCell", forIndexPath: indexPath) as! LinkTableViewCell
        
        let link = links[indexPath.row]
        
        cell.assignValuesFromLink(link)
        
        return cell
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return links.count
    }
}
