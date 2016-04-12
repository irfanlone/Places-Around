//
//  NetworkingTests.swift
//  Quick-Coffee
//
//  Created by Irfan Lone on 4/12/16.
//  Copyright © 2016 Ilone Labs. All rights reserved.
//

import XCTest
import Foundation
import UIKit


class NetworkingTests: XCTestCase {
    
    var netwrk : Networking!
    
    class Fake_Networking : NetworkProtocol {
        
        func getDataAtUrl(url: NSURL, completion:(Bool, NetworkResponseObj) -> (Void)) {
        
        }
        
    }
    
    override func setUp() {
        super.setUp()
        
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func test_getDataAtUrl() {
        
        let netwrkng = Networking()
        let url = NSURL(string: "")
        netwrkng.getDataAtUrl(url!) { (sucess, NetworkResponseObj) -> (Void) in
            
        }
        
    }
    
    func testPerformanceExample() {
        self.measureBlock {
        }
    }
    
}
