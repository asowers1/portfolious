//
//  ImageFromServerURL.swift
//  Portfolious
//
//  Created by Andrew Sowers on 7/31/16.
//  Copyright © 2016 Andrew Sowers. All rights reserved.
//
//  Bluntly copped from https://stackoverflow.com/questions/37018916/swift-async-load-image
//

import UIKit

extension UIImageView {
    public func imageFromServerURL(_ urlString: String) {
        
        URLSession.shared.dataTask(with: URL(string: urlString)!, completionHandler: { (data, response, error) -> Void in
			
            DispatchQueue.main.async(execute: { () -> Void in
                let image = UIImage(data: data!)
                self.image = image
            })
            
        }).resume()
    }
}
