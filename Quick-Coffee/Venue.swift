//
//  Venue.swift
//  Quick-Coffee
//
//  Created by Irfan Lone on 3/20/16.
//  Copyright © 2016 Ilone Labs. All rights reserved.
//

import Foundation

struct Location {
    
    var address : String!
    var lattitue : Float64!
    var longitude : Float64!
    var distance : Float64!
    
    init() {
        self.address = ""
        self.lattitue = 0.0
        self.longitude = 0.0
        self.distance = 0.0
    }
    
    init(_address: String, _latitude: Float64, _longitude: Float64, _distance: Float64) {
        self.address = _address
        self.lattitue = _latitude
        self.longitude = _longitude
        self.distance = _distance
    }
}

struct Venue {
    
    var identifier : String!
    var name : String!
    var location : Location!
    var website : String!
    var menuUrl : String!
    var phoneNumber : String!
    var iconUrl : String!
    
    init() {
        self.identifier = ""
        self.name = ""
        self.website = ""
        self.menuUrl = ""
        self.phoneNumber = "'"
        self.iconUrl = ""
        self.location = Location()
    }
    
    init(_id: String, _name: String, _address: String, _website: String, _menuUrl: String, _phone: String, _distance: Float64, _lat: Float64, _lng: Float64, _iconUrl: String) {
        self.identifier = _id
        self.name = _name
        self.website = _website
        self.menuUrl = _menuUrl
        self.phoneNumber = _phone
        self.iconUrl = _iconUrl
        self.location = Location.init(_address: _address, _latitude: _lat, _longitude: _lng, _distance: _distance)
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

