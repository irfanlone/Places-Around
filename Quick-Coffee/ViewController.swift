//
//  ViewController.swift
//  Quick-Coffee
//
//  Created by Irfan Lone on 3/19/16.
//  Copyright © 2016 Ilone Labs. All rights reserved.
//


let kCLIENTID = "2M4QBWYTS5GO3EJGQYK3USK5XM0JZ0SFBELQBQPAKUFKXQ2L"
let kCLIENTSECRET = "TNYFKM4SNJVC4QTOZ2HWOZEUQGSXWZNCR0EYMHPOQNTF4GHG"


import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var list: NSMutableArray!
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        list = NSMutableArray()
        let netWrkObj = Networking()
        
        let baseUrl = "https://api.foursquare.com/"
        let operation = "v2/venues/search?"
        let categoryId = "4bf58dd8d48988d1e0931735"
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        let dateStr = dateFormatter.stringFromDate(NSDate())
        
        let urlString = NSString(format: "%@%@categoryId=%@&client_id=%@&client_secret=%@&ll=40.7,-74&v=%@", baseUrl,operation,categoryId,kCLIENTID,kCLIENTSECRET,dateStr)

        let url = NSURL(string: urlString as String)
        netWrkObj.getDataAtUrl(url!) { (success, data) -> (Void) in
            if success == false {
                return;
            }
            var parsed : AnyObject!
            do {
                parsed = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments)
                print(parsed)
            }
            catch let error as NSError {
                print("A JSON parsing error occurred, here are the details:\n \(error)")
            }
            self.processJsonData(parsed)
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.tableView.reloadData()
            })
        }
    }

    func processJsonData(json: AnyObject) {
        let response = json.valueForKey("response")
        let venues: NSArray = response?.valueForKey("venues") as! NSArray
        self.list = venues.mutableCopy() as! NSMutableArray;
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let reuseIdentifier = "cell";
        let cell = tableView .dequeueReusableCellWithIdentifier(reuseIdentifier, forIndexPath: indexPath)
        let obj = list.objectAtIndex(indexPath.row) as? NSDictionary
        cell.textLabel?.text = obj?.valueForKey("name") as? String
        return cell;
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    
    }

}

