//
//  VenuesControllerTests.swift
//  Quick-Coffee
//
//  Created by Irfan Lone on 4/19/16.
//  Copyright © 2016 Ilone Labs. All rights reserved.
//

import XCTest
import UIKit
import Foundation

@testable import Quick_Coffee

class VenuesControllerTests: XCTestCase {
    
    var ven_Cntrlr : venuesController!
    var inputJson : AnyObject!
    var output = [Venue]()


    override func setUp() {
        super.setUp()
        
        ven_Cntrlr = venuesController()
        
        // create input
        inputJson = ["response" : [
            "venues": [
                [
                    "name" : "test-venue-name-01",
                    "url" : "test-venue-url-01",
                    "id" : "test-id-01",
                    "menu" : [
                        "url" : "xyz.com"
                    ],
                    "location" : [
                        "distance" : 1.5,
                        "address" : "1012 ackerman ave",
                        "city" : "santa clara",
                        "lat" : 123,
                        "lng" : 123
                    ],
                    "contact" : [
                        "formattedPhone" : "123-123-123"
                    ],
                ],
                [
                    "name" : "test-venue-name-02",
                    "url" : "test-venue-url-02",
                    "id" : "test-id-02",
                    "menu" : [
                        "url" : "ayz.com"
                    ],
                    "location" : [
                        "distance" : 2.5,
                        "address" : "10 ackerman ave",
                        "city" : "palo alto",
                        "lat" : 234,
                        "lng" : 234
                    ],
                    "contact" : [
                        "formattedPhone" : "123-123-123"
                    ],
                ]
            ]
            ]
        ]
        
        // create output : - venues array
        let item1 = Venue(_id: "test-id-01", _name: "test-venue-name-01", _address: "1012 ackerman ave, santa clara", _website: "test-venue-url-01", _menuUrl: "xyz.com", _phone: "123-123-123", _distance: 1.5, _lat: 123, _lng: 123, _iconUrl: "one")
        let item2 = Venue(_id: "test-id-02", _name: "test-venue-name-02", _address: "10 ackerman ave, palo alto", _website: "test-venue-url-02", _menuUrl: "ayz.com", _phone: "123-123-123", _distance: 2.5, _lat: 234, _lng: 234, _iconUrl: "two")
        
        output = [item1, item2]
    }
    
    
    
    override func tearDown() {
        super.tearDown()
        ven_Cntrlr = nil
        inputJson = nil
    }

    func testProcessJsonDataToVenuesCheckDataCount() {
        
        let result = venuesController.processJsonDataToVenues(inputJson)
        XCTAssertTrue(result.count == output.count, "Falied to process the json successfully, Incorrect count")
    }
    
    

    func testProcessJsonDataToVenuesMatchData() {
        
        var result = venuesController.processJsonDataToVenues(inputJson)
        
        result = result.sort { $0.name > $1.name  && $0.identifier > $1.identifier }
        let firstObj = result.first
        
        output = output.sort { $0.name > $1.name  && $0.identifier > $1.identifier  }
        let fake_obj = output.first
        
        // Sort the array to check for correct objects
        
        XCTAssertTrue(firstObj?.name == fake_obj!.name, "Failed to convert data, Venue name doesn't match")
        
        XCTAssertTrue(firstObj?.identifier == fake_obj!.identifier, "Failed to convert data, Venue id doesn't match")
        
        XCTAssertTrue(firstObj?.website == fake_obj!.website, "Failed to convert data, Venue website doesn't match")
        
        XCTAssertTrue(firstObj?.location.address == fake_obj!.location.address, "Failed to convert data, Venue address doesn't match")
        
        XCTAssertTrue(firstObj?.location.distance == fake_obj!.location.distance, "Failed to convert data, Venue distance doesn't match")
        
        XCTAssertTrue(firstObj?.location.lattitue == fake_obj!.location.lattitue, "Failed to convert data, Venue lat doesn't match")
        
        XCTAssertTrue(firstObj?.location.longitude == fake_obj!.location.longitude, "Failed to convert data, Venue long doesn't match")
        
        XCTAssertTrue(firstObj?.menuUrl == fake_obj!.menuUrl, "Failed to convert data, Venue menu url doesn't match")
        
        XCTAssertTrue(firstObj?.phoneNumber == fake_obj!.phoneNumber, "Failed to convert data, Venue phone number doesn't match")

    }

}
