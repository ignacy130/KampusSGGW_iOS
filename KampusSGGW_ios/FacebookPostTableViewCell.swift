//
//  FacebookPostTableViewCell.swift
//  KampusSGGW
//
//  Created by Pawel Sygnowski on 31/10/15.
//  Copyright © 2015 QexT. All rights reserved.
//

import UIKit

class FacebookPostTableViewCell: UITableViewCell {
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var picture: UIImageView!
    @IBOutlet weak var message: TopAlignedLabel!
}

extension FacebookPostTableViewCell{
    func assignValuesFromFacebookPost(post: FacebookPost){
        message.text = post.message
        title.text = post.message
        ImageLoader.getImageFromUrl(post.picture) { (image) -> Void in
            dispatch_async(dispatch_get_main_queue(), {
                self.picture.image = UIImage(data: image)
            })
        }
    }
}

class ImageLoader{
    class func getImageFromUrl(pictureUrl: String, onDownload: NSData -> Void){
        let url = NSURL(string: pictureUrl)
        let downloadTask = NSURLSession.sharedSession().dataTaskWithURL(url!) { (data, response, error) -> Void in
            guard error == nil && data != nil else{
                print(error)
                //assignTo = default image
                return
            }
            onDownload(data!)
        }
        
        downloadTask.resume()
    }
}