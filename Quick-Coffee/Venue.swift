//
//  Venue.swift
//  Quick-Coffee
//
//  Created by Irfan Lone on 3/20/16.
//  Copyright © 2016 Ilone Labs. All rights reserved.
//


struct Venue {
    
    var name : String!
    var address : String!
    var website : String!
    var menuUrl : String!
    var phoneNumber : String!
    var distance : Float64!
    var iconUrl : String!
    
    init() {
        self.name = ""
        self.address = ""
        self.website = ""
        self.menuUrl = ""
        self.phoneNumber = "'"
        self.distance = 0.0
        self.iconUrl = ""
    }
    
    init(_name: String, _address: String, _website: String, _menuUrl: String, _phone: String, _distance: Float64, _iconUrl: String) {
        self.name = _name
        self.address = _address
        self.website = _website
        self.menuUrl = _menuUrl
        self.phoneNumber = _phone
        self.distance = _distance
        self.iconUrl = _iconUrl
    }
}