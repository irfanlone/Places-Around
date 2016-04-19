//
//  VenuesController.swift
//  Quick-Coffee
//
//  Created by Irfan Lone on 4/12/16.
//  Copyright © 2016 Ilone Labs. All rights reserved.
//

import Foundation
import CoreLocation



struct venuesController  {
    
    let baseUrl = "https://api.foursquare.com/"
    
    func getVenuesForCategory(category: ItemCategory, location : CLLocation, operation: String = "v2/venues/search?", completionHandler: [Venue] -> (Void)) {
        
        let categoryId: String = category.stringValue()
        
        let urlString = NSString(format: "%@%@categoryId=%@&client_id=%@&client_secret=%@&ll=%f%%2C%f&v=%@", baseUrl,operation,categoryId,kCLIENTID,kCLIENTSECRET,location.coordinate.latitude,location.coordinate.longitude,dateStringForCurrentDate())
        
        venuesController.getVenuesAtUrlString(urlString as String) { venues -> (Void) in
            completionHandler(venues)
        }
    }
    
    func getVenuesForSearchString(searchString: String, location : CLLocation, operation: String = "v2/venues/search?", completionHandler: [Venue] -> (Void)) {
        
        let searchTerm = searchString.stringByReplacingOccurrencesOfString(" ", withString: "+")
        
        let urlString = NSString(format: "%@%@query=%@&client_id=%@&client_secret=%@&ll=%f%%2C%f&v=%@", baseUrl,operation,searchTerm,kCLIENTID,kCLIENTSECRET,location.coordinate.latitude,location.coordinate.longitude,dateStringForCurrentDate())
        
        venuesController.getVenuesAtUrlString(urlString as String) { venues -> (Void) in
            completionHandler(venues)
        }
    }
    
    static func getVenuesAtUrlString(urlString: String, ntwrkng: Networking = Networking() ,completionHandler: [Venue] -> (Void)) {
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
            
            let list = venuesController.processJsonDataToVenues(parsed)
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                completionHandler(list)
            })

        }
    }
    
    static func processJsonDataToVenues(json: AnyObject) -> [Venue] {
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
            
            var street : String = ""
            var city : String = ""
            var latitude : Float64 = 0.0
            var longitude : Float64 = 0.0
            var distance : Float64!

            if let location = venueItem!["location"] {
                
                if let st = location["address"] where st != nil {
                    street = st as! String
                }
                
                if let cty = location["city"] where cty != nil {
                    city  = cty as! String
                }
                
                if let dst = location["distance"] {
                    distance = dst as! Float64
                }
                
                if let lat = location["lat"] {
                    latitude = lat as! Float64
                }
                
                if let lon = location["lng"] {
                    longitude = lon as! Float64
                }
            }
            
            let address = "\(street), \(city)"
            
            var phoneNumber : String = ""
            
            if  let contact = venueItem!["contact"] {
                if let phone = contact["formattedPhone"] where phone != nil {
                    phoneNumber = phone as! String
                }
            }
            
            var menuUrl : String = ""
            if let menu = venueItem!["menu"] {
                if let menuUrlStr = menu["url"] {
                    menuUrl = menuUrlStr as! String
                }
            }
            
            let identifier = venueItem!["id"] as! String
            
            assert(distance != nil)
            
            let venueObj = Venue(_id: identifier, _name: name, _address: address, _website: url, _menuUrl:menuUrl, _phone: phoneNumber, _distance: distance, _lat: latitude, _lng: longitude, _iconUrl: "")
            list.append(venueObj)
            
        }
        // sort the list
        list.sortInPlace({$0.location.distance < $1.location.distance})
        
        return list
    }
    
    
}