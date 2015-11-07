//
//  FacebookPostsController.swift
//  KampusSGGW
//
//  Created by Pawel Sygnowski on 07/11/15.
//  Copyright © 2015 QexT. All rights reserved.
//

import UIKit

class FacebookPostsController : UITableViewController{
    var pageId: String?
    var posts = [FacebookPost]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.refreshControl?.addTarget(self, action: "getPosts", forControlEvents: .ValueChanged)
        getPosts()
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let post = posts[indexPath.row]
        
        post.open()
    }
    
    func getPosts(){
        if posts.count == 0{
            if let height = self.refreshControl?.frame.size.height{
                self.tableView.setContentOffset(CGPointMake(0, -height), animated: true)
            }
        }
        self.refreshControl?.beginRefreshing()
        
        guard pageId != nil else{
            return
        }
        
        FacebookGraphAPI.getPosts(pageId!, successCallback: self.postsDownloadedCallback, failureCallback: self.showMessageBecauseErrorOccured)
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if posts.count == 0{
            self.tableView?.backgroundView?.hidden = false
        }
        else{
            self.tableView?.backgroundView?.hidden = true
        }
        return posts.count
    }
    
    func postsDownloadedCallback(posts: [FacebookPost]){
        self.posts = posts
        self.tableView.reloadData()
        self.refreshControl?.endRefreshing()
    }
    
    func showMessageBecauseErrorOccured(){
        let emptyLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height))
        emptyLabel.text = "Wystąpił błąd. Przesuń w dół, żeby odświeżyć."
        emptyLabel.numberOfLines = 0
        emptyLabel.textAlignment = .Center
        emptyLabel.sizeToFit()
        
        self.tableView.backgroundView = emptyLabel
        
        self.refreshControl?.endRefreshing()
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("facebookPostCell", forIndexPath: indexPath) as! FacebookPostTableViewCell
        
        let post = posts[indexPath.row]
        
        cell.assignValuesFromFacebookPost(post)
        
        return cell
    }
}
