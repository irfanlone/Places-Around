//
//  Helper.swift
//  Quick-Coffee
//
//  Created by Irfan Lone on 4/12/16.
//  Copyright © 2016 Ilone Labs. All rights reserved.
//

import Foundation

protocol PhotosGettable {
    
    func getPhotoForVenue(venueId: String ,completion:([AnyObject]) -> (Void))

}


struct DownloadPhotos : PhotosGettable {
    
    func getPhotoForVenue(venueId: String ,completion:([AnyObject]) -> (Void)) {
        
        let baseUrl = "https://api.foursquare.com/v2/venues/"
        let operation = "/photos?"
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        let dateStr = dateFormatter.stringFromDate(NSDate())
        
        let urlString = NSString(format: "%@%@%@&client_id=%@&client_secret=%@&v=%@&limit=200", baseUrl,venueId,operation,kCLIENTID,kCLIENTSECRET,dateStr)
        
        let url = NSURL(string: urlString as String)
        Networking().getDataAtUrl(url!) { (success, obj) -> (Void) in
            if success == false {
                completion([])
                return
            }
            var parsed : AnyObject!
            do {
                parsed = try NSJSONSerialization.JSONObjectWithData(obj.data, options: NSJSONReadingOptions.AllowFragments)
            }
            catch let error as NSError {
                print("A JSON parsing error, Details:\n \(error)")
            }
            let response = parsed.valueForKey("response") as! NSDictionary
            let photos = response.valueForKey("photos") as! NSDictionary
            let items = photos.valueForKey("items") as! NSArray
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                completion(items as [AnyObject])
            })
        }
    }
    
    
}
