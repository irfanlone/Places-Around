//
//  Networking.swift
//  Quick-Coffee
//
//  Created by Irfan Lone on 3/20/16.
//  Copyright © 2016 Ilone Labs. All rights reserved.
//

import UIKit


typealias ClosureType = (Bool, NSData) -> (Void)

class Networking: NSObject {
    
    func getDataAtUrl(url: NSURL, completion: ClosureType) {
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithURL(url, completionHandler: { (data, response, error) -> Void in
            
            if error != nil {
                // failure
                print("error: \(error!.localizedDescription): \(error!.userInfo)")
                completion(false, data!)
            }
            else if data != nil {
                // success
                completion(true, data!)

            }
        })
        task.resume()
    }
}

