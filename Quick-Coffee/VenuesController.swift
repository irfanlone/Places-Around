//
//  VenuesController.swift
//  Quick-Coffee
//
//  Created by Irfan Lone on 4/12/16.
//  Copyright © 2016 Ilone Labs. All rights reserved.
//

import Foundation
import CoreLocation

protocol VenuesGettable {
    
    func getVenuesForCategory(ct: ItemCategory, location : CLLocation, completionHandler: [Venue] -> (Void))
    
    func getVenuesForSearchString(ct: String, location : CLLocation, completionHandler: [Venue] -> (Void))
    
    func getVenuesAtUrlString(urlString: String, ntwrkng: Networking, completionHandler: [Venue] -> (Void))
    
}


struct venuesController : VenuesGettable {
    
    let baseUrl = "https://api.foursquare.com/"
    let operation = "v2/venues/search?"
    
    
    func getVenuesForCategory(category: ItemCategory, location : CLLocation, completionHandler: [Venue] -> (Void)) {
        
        let categoryId: String = category.stringValue()
        
        let urlString = NSString(format: "%@%@categoryId=%@&client_id=%@&client_secret=%@&ll=%f%%2C%f&v=%@", baseUrl,operation,categoryId,kCLIENTID,kCLIENTSECRET,location.coordinate.latitude,location.coordinate.longitude,dateStringForCurrentDate())
        
        getVenuesAtUrlString(urlString as String) { venues -> (Void) in
            completionHandler(venues)
        }
    }
    
    func getVenuesForSearchString(searchString: String, location : CLLocation, completionHandler: [Venue] -> (Void)) {
        
        let searchTerm = searchString.stringByReplacingOccurrencesOfString(" ", withString: "+")
        
        let urlString = NSString(format: "%@%@query=%@&client_id=%@&client_secret=%@&ll=%f%%2C%f&v=%@", baseUrl,operation,searchTerm,kCLIENTID,kCLIENTSECRET,location.coordinate.latitude,location.coordinate.longitude,dateStringForCurrentDate())
        
        getVenuesAtUrlString(urlString as String) { venues -> (Void) in
            completionHandler(venues)
        }
    }
    
    func getVenuesAtUrlString(urlString: String, ntwrkng: Networking = Networking() ,completionHandler: [Venue] -> (Void)) {
        let url = NSURL(string: urlString as String)
        ntwrkng.getDataAtUrl(url!) { (success, obj) -> (Void) in
            guard success == true else {
                return
            }
            var parsed : AnyObject!
            do {
                parsed = try NSJSONSerialization.JSONObjectWithData(obj.data, options: NSJSONReadingOptions.AllowFragments)
            }
            catch let error as NSError {
                print("A JSON parsing error occurred, details:\n \(error)")
            }
            let list = self.processJsonDataToVenues(parsed)
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                completionHandler(list)
            })
        }
    }
    
    private func processJsonDataToVenues(json: AnyObject) -> [Venue] {
        let response = json.valueForKey("response")
        let venues: NSArray = response?.valueForKey("venues") as! NSArray
        
        var list : [Venue] = []
        
        for i in 0 ..< venues.count {
            let venueItem = venues[i] as? NSDictionary
            let name = venueItem!["name"] as! String
            
            var url: String = ""
            if let websiteUrl = venueItem!["url"] {
                url = websiteUrl as! String
            }
            
            let location = venueItem!["location"] as! NSDictionary
            var street : String = ""
            if let st = location["address"] {
                street = st as! String
            }
            var city : String = ""
            if let cty = location["city"] {
                city  = cty as! String
            }
            let address = "\(street), \(city)"
            let distance = location["distance"] as! Float64
            let latitude = location["lat"] as! Float64
            let longitude = location["lng"] as! Float64
            
            let contact = venueItem!["contact"] as! NSDictionary
            var phoneNumber : String = ""
            if let phone = contact["formattedPhone"] {
                phoneNumber = phone as! String
            }
            
            var menuUrl : String = ""
            if let menu = venueItem!["menu"] {
                let dict = menu as! NSDictionary
                menuUrl = dict["url"] as! String
            }
            
            let identifier = venueItem!["id"] as! String
            
            let venueObj = Venue(_id: identifier, _name: name, _address: address, _website: url, _menuUrl:menuUrl, _phone: phoneNumber, _distance: distance, _lat: latitude, _lng: longitude, _iconUrl: "")
            list.append(venueObj)
            
        }
        // sort the list
        list.sortInPlace({$0.location.distance < $1.location.distance})
        
        return list
    }
    
    
}