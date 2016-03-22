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
import CoreLocation


class ViewController: UIViewController {

    var list : [Venue] = []
    var locationManager : CLLocationManager!
    var currentLocation : CLLocation!
    @IBOutlet var tableView: UITableView!
    var selectedIndexPath : NSIndexPath!
    var activityIndicator : UIActivityIndicatorView!
    
    override func loadView() {
        super.loadView()
        self.activityIndicator = UIActivityIndicatorView(activityIndicatorStyle:.WhiteLarge)
        self.activityIndicator.color = UIColor.grayColor()
        self.view.addSubview(self.activityIndicator)
        self.activityIndicator.startAnimating()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        let viewBounds : CGRect = self.view.bounds
        self.activityIndicator.center = CGPointMake(CGRectGetMidX(viewBounds), CGRectGetMidY(viewBounds))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initLocationManager()
    }

    func initLocationManager() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.distanceFilter = kCLLocationAccuracyHundredMeters
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func loadVenues() {
        self.list.removeAll()

        let netWrkObj = Networking()
        let baseUrl = "https://api.foursquare.com/"
        let operation = "v2/venues/search?"
        let categoryId = "4bf58dd8d48988d1e0931735"
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        let dateStr = dateFormatter.stringFromDate(NSDate())
        
        let urlString = NSString(format: "%@%@categoryId=%@&client_id=%@&client_secret=%@&ll=%f%%2C%f&v=%@", baseUrl,operation,categoryId,kCLIENTID,kCLIENTSECRET,self.currentLocation.coordinate.latitude,self.currentLocation.coordinate.longitude ,dateStr)
        
        let url = NSURL(string: urlString as String)
        netWrkObj.getDataAtUrl(url!) { (success, obj) -> (Void) in
            guard success == true else {
                return;
            }
            var parsed : AnyObject!
            do {
                parsed = try NSJSONSerialization.JSONObjectWithData(obj.data, options: NSJSONReadingOptions.AllowFragments)
            }
            catch let error as NSError {
                print("A JSON parsing error occurred, here are the details:\n \(error)")
            }
            self.processJsonData(parsed)
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.tableView.reloadData()
                self.activityIndicator.stopAnimating()
            })
        }
    }

    func processJsonData(json: AnyObject) {
        let response = json.valueForKey("response")
        let venues: NSArray = response?.valueForKey("venues") as! NSArray
        
        for i in 0 ..< venues.count {
            let venueItem = venues[i] as? NSDictionary
            let name = venueItem!["name"] as! String
            
            var url: String!
            if let websiteUrl = venueItem!["url"] {
                url = websiteUrl as! String
            } else {
                url = ""
            }
            
            let location = venueItem!["location"] as! NSDictionary
            let street = location["address"] as! String
            let city = location["city"] as! String
            let address = "\(street), \(city)"
            let distance = location["distance"] as! Float64
            let latitude = location["lat"] as! Float64
            let longitude = location["lng"] as! Float64

            let contact = venueItem!["contact"] as! NSDictionary
            var phoneNumber : String!
            if let phone = contact["formattedPhone"] {
                phoneNumber = phone as! String
            } else {
                phoneNumber = ""
            }
            
            var menuUrl : String!
            if let menu = venueItem!["menu"] {
               let dict = menu as! NSDictionary
                menuUrl = dict["url"] as! String
            } else {
                menuUrl = ""
            }
            
            let identifier = venueItem!["id"] as! String
            
            let venueObj = Venue(_id: identifier, _name: name, _address: address, _website: url, _menuUrl:menuUrl, _phone: phoneNumber, _distance: distance, _lat: latitude, _lng: longitude, _iconUrl: "")
            self.list.append(venueObj)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "detail" {
            let dvc = segue.destinationViewController as! DetailViewController
            dvc.venue = self.list[self.selectedIndexPath.row]
        }
    }

}


extension ViewController : CLLocationManagerDelegate {

    // MARK: - Location Manager
    
    func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation) {
        if (self.currentLocation == nil) {
            self.currentLocation = CLLocation()
        }
        self.currentLocation = newLocation;
        self.loadVenues()
    }

}

