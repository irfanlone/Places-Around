//
//  Networking.swift
//  Quick-Coffee
//
//  Created by Irfan Lone on 3/20/16.
//  Copyright © 2016 Ilone Labs. All rights reserved.
//

import UIKit


struct NetworkResponseObj {
    
    var data: NSData!
    var response: NSHTTPURLResponse!
    var error: NSError!
    
    init() {
        self.data = nil
        self.response = nil
        self.error = nil
    }
    
    init(_data: NSData, _response: NSHTTPURLResponse, _error: NSError!) {
        self.data = _data
        self.response = _response
        self.error = _error
    }
}



protocol NetworkProtocol {
    
    func getDataAtUrl(url: NSURL, completion:(Bool, NetworkResponseObj) -> (Void))

}

struct Networking : NetworkProtocol {
    
    func getDataAtUrl(url: NSURL, completion:(Bool, NetworkResponseObj) -> (Void)) {
        
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithURL(url, completionHandler: { (data, response, error) -> Void in
            
            guard let respose = response else {
                let resObj = NetworkResponseObj()
                completion(false, resObj)
                return
            }
            
            let httpRespose = respose as! NSHTTPURLResponse
            let responseObj = NetworkResponseObj(_data: data!, _response: httpRespose, _error: error)
            
            if error != nil {
                print("error: \(error!.localizedDescription): \(error!.userInfo)")
                completion(false, responseObj)
            }
            else if data != nil {
                completion(true, responseObj)
            }
            
        })
        task.resume()
    }
}

