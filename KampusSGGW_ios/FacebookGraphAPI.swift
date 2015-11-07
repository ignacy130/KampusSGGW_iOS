//
//  FacebookGraphAPI.swift
//  KampusSGGW
//
//  Created by Pawel Sygnowski on 07/11/15.
//  Copyright © 2015 QexT. All rights reserved.
//

import UIKit
import FBSDKCoreKit

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
                        print(post)
                        if let id = post["id"] as? String, let message = post["message"] as? String, let picture = post["picture"] as? String{
                            posts.append(FacebookPost(id: id, message: message, picture: picture, objectId: post["object_id"] as? String))
                        }
                    }
                }
            }
        }
        return posts
    }
    
    class func getPostsFromFacebookAPI(pageId: String, accessToken: String, successCallback: [FacebookPost] -> Void, failureCallback: Void -> Void){
        
        let params = [ "access_token": accessToken, "fields": "id, object_id, message, story, picture, status_type", "locale": "pl_PL", "limit": "20" ]
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
                failureCallback()
                return
            }
            if let dictionary = result as? NSDictionary{
                if let accessToken = dictionary.valueForKey("access_token") as? String{
                    successCallback(accessToken)
                    return
                }
            }
            
            failureCallback()
        }
        
    }
}

