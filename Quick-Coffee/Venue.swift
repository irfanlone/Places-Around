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

}
