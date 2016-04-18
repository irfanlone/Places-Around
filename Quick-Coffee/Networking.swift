//
//  Networking.swift
//  Quick-Coffee
//
//  Created by Irfan Lone on 3/20/16.
//  Copyright © 2016 Ilone Labs. All rights reserved.
//

import UIKit

protocol NetworkProtocol {
    
    func getDataAtUrl(url: NSURL, session: NSURLSession, completion:(Bool, NetworkResponseObj) -> (Void))
    
}

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


class Networking : NetworkProtocol {
    
    var completion: ((Bool, NetworkResponseObj) -> Void)!
    
    func getDataAtUrl(url: NSURL, session: NSURLSession = NSURLSession.sharedSession(),  completion:(Bool, NetworkResponseObj) -> (Void)) {
        
        self.completion = completion
        let task = session.dataTaskWithURL(url, completionHandler: parseServerData)
        task.resume()
    }
    
    func parseServerData(data: NSData?, response: NSURLResponse?, error: NSError?) {

        guard error == nil else {
            print("error: \(error!.localizedDescription): \(error!.userInfo)")
            return
        }

        guard let data = data else {
            print("Failed to download data from server.")
            return
        }
        
        var httpRespose : NSHTTPURLResponse!
        if response != nil  {
            httpRespose = response as! NSHTTPURLResponse
        } else {
            print("Failed to get the response.")
            return
        }
        
        let responseObj = NetworkResponseObj(_data: data, _response: httpRespose, _error: error)
        
        completion!(true, responseObj)
    }
    
}

