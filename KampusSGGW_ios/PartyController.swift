//
//  PartyController.swift
//  KampusSGGW
//
//  Created by Pawel Sygnowski on 31/10/15.
//  Copyright © 2015 QexT. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import FBSDKShareKit

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

class FacebookGraphAPI{
    class func getPosts(pageId: String, successCallback: [FacebookPost] -> Void, failureCallback: Void -> Void){
        getAccessToken({ (accessToken) -> Void in
            getPostsFromFacebookAPI(pageId, accessToken: accessToken, successCallback: successCallback, failureCallback: failureCallback)
        },
        failureCallback: failureCallback)
    }
    
    class func parse(results: AnyObject) -> [FacebookPost]{
        var posts = [FacebookPost]()
        if let json = results as? NSDictionary{
            if let data = json["data"] as? NSArray{
                for item in data{
                    if let post = item as? NSDictionary{
                        if let message = post["message"] as? String, let picture = post["picture"] as? String{
                            posts.append(FacebookPost(message: message, picture: picture, objectId: post["object_id"] as? String))
                        }
                    }
                }
            }
        }
        return posts
    }
    
    class func getPostsFromFacebookAPI(pageId: String, accessToken: String, successCallback: [FacebookPost] -> Void, failureCallback: Void -> Void){
        
        let params = [ "access_token": accessToken, "fields": "object_id, message, story, picture, status_type", "locale": "pl_PL", "limit": "20" ]
        let request = FBSDKGraphRequest(graphPath: "/\(pageId)/posts", parameters: params, HTTPMethod: "GET")
        request.startWithCompletionHandler { (connection, results, error) -> Void in
            if error != nil{
                failureCallback()
                return;
            }
            successCallback(FacebookGraphAPI.parse(results))
        }
    }
    
    class func getAccessToken(successCallback: String -> Void, failureCallback: Void -> Void){
        let facebookConfig = FacebookConfig.getDefault()
        
        let paramsForAccessToken = [ "client_id": facebookConfig.clientId, "client_secret": facebookConfig.clientSecret, "grant_type": "client_credentials", "fields": "access_token" ]
        let requestForAccessToken = FBSDKGraphRequest(graphPath: "/oauth/access_token", parameters: paramsForAccessToken, HTTPMethod: "GET")
        requestForAccessToken.startWithCompletionHandler { (connection, result, error) -> Void in
            if error != nil{
                //coś trzeba zrobić jak jest bład, może wyświetlić na UI?
                failureCallback()
                print(error)
                return
            }
            if let dictionary = result as? NSDictionary{
                if let accessToken = dictionary.valueForKey("access_token") as? String{
                    //graph.facebook.com/291726291971/posts?access_token=837519593012071|cvYZsT3qP3XMTu4r95IT6i7emas
                    successCallback(accessToken)
                    return
                }
            }
            
            failureCallback()
        }

    }
}

class FacebookPost{
    var objectId: String?
    var message: String
    var picture: String
    
    init(message: String, picture: String, objectId: String?){
        self.message = message
        self.picture = picture
        self.objectId = objectId
    }
}

class PartyController: UITableViewController {
     var posts = [FacebookPost]()
    
    func showMessageBecauseErrorOccured(){
        print("ERROR!")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //
        FacebookGraphAPI.getPosts("154574734618988", successCallback: self.postsDownloadedCallback, failureCallback: self.showMessageBecauseErrorOccured)
        
        //var access_token = FBSDKAccessToken.currentAccessToken()
        //print(access_token)
        
        //let request = FBSDKGraphRequest(graphPath: "/291726291971/feed", parameters: nil, HTTPMethod: "GET")
        //request.startWithCompletionHandler { (connection, results, error) -> Void in
        //    print(results);
        //    print(error);
        //}
    }
    
    func postsDownloadedCallback(posts: [FacebookPost]){
        print("posts downloaded")
        self.posts = posts
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("facebookPostCell", forIndexPath: indexPath) as! FacebookPostTableViewCell
        
        let post = posts[indexPath.row]
        
        cell.assignValuesFromFacebookPost(post)
        
        return cell
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return posts.count
    }
}
