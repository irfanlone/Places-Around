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
    var completionInvoked = false
    
    /*
     1. If no response data, completion should not be invoked
     2. If error, completion should not be invoked
     3. If no httpResponse, completion should not be invoked
     4. valid response, no error - completion should be invioked
 
 */
    override func setUp() {
        super.setUp()
        netwrk = Networking()
    }
    
    override func tearDown() {
        super.tearDown()
        netwrk = nil
    }
    
    func test_parseServerDataDoesntCallCompletionForError() {
        let error = NSError(domain: "test error", code: 400, userInfo: nil)
        netwrk.completion = fakeCompletion
        netwrk.parseServerData(nil, response: nil, error: error)
        
        XCTAssertFalse(completionInvoked, "Completion closure must not be called in case of error.")
    }
    
    func test_parseServerDataForDoesntCallCompletionWithForNoData() {
        netwrk.completion = fakeCompletion
        netwrk.parseServerData(nil, response: nil, error: nil)
        
        XCTAssertFalse(completionInvoked, "Completion closure must not be called in case of broken data.")
    }
    
    func test_parseServerDataForDoesntCallCompletionWithNoReponse() {
        let goodJsonData = "[ {\"name\": \"Juanita Banana\"} ]".dataUsingEncoding(NSUTF8StringEncoding)
        netwrk.completion = fakeCompletion
        netwrk.parseServerData(goodJsonData, response: nil, error: nil)
        
        XCTAssertFalse(completionInvoked, "Completion closure must not be called in case of in case of no response.")
    }

    func test_parseServerDataForCallsCompletionWithProperData() {
        let goodJsonData = "[ {\"name\": \"quick coffee\"} ]".dataUsingEncoding(NSUTF8StringEncoding)
        let httpResponse = NSHTTPURLResponse(URL: NSURL(string: "")!, statusCode: 200, HTTPVersion: "1.0", headerFields: ["":""])
        netwrk.completion = fakeCompletion
        netwrk.parseServerData(goodJsonData, response: httpResponse, error: nil)
        
        XCTAssertTrue(completionInvoked, "Completion closure must be called in case of proper response and data.")
    }
    
    func fakeCompletion(_: Bool, _: NetworkResponseObj) -> Void {
        completionInvoked = true
    }
    
    
}
