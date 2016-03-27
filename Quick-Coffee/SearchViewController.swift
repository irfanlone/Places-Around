//
//  SearchViewController.swift
//  Quick-Coffee
//
//  Created by Irfan Lone on 3/25/16.
//  Copyright © 2016 Ilone Labs. All rights reserved.
//

import UIKit

class SearchViewController : UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var searchTextField: UITextField!
    var tableView : UITableView!
    var list : [Venue] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func searchPressed(sender: AnyObject) {
        self.loadVenues()
    }
    
    
    @IBAction func test(sender: AnyObject) {
        self.tableView.removeFromSuperview()
    }
    
    private func loadResultsTableView() {
//        var frame = self.view.bounds
//        frame.origin.x -= self.view.frame.size.width
//        frame.origin.y += 80
//        frame.size.height -= 80
//        tableView = UITableView(frame: frame, style: UITableViewStyle.Plain)
//        tableView.registerClass(VenueTableCell.self, forCellReuseIdentifier: "cell")
//        tableView.dataSource = dataSource
//        self.view.addSubview(tableView)
//        
//        UIView.animateWithDuration(1.5, delay: 0.1 * Double(1), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: [], animations: {
//            self.tableView.frame.origin.x = 0
//
//            }, completion: nil)
//
//
        
//        let views = ["view": tableView]
//        let horizontalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[view]-0-|", options: NSLayoutFormatOptions.AlignAllCenterY, metrics: nil, views: views)
//        view.addConstraints(horizontalConstraints)
//        let verticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|-80-[view]-0-|", options: NSLayoutFormatOptions.AlignAllCenterY, metrics: nil, views: views)
//        view.addConstraints(verticalConstraints)
        
        let venuesTableVC = UIStoryboard(name: "Venues", bundle: nil).instantiateViewControllerWithIdentifier("venuesTable") as! VenueTableViewController
        venuesTableVC.venues = self.list
        self.addChildViewController(venuesTableVC)
        self.view.addSubview(venuesTableVC.view)
        venuesTableVC.didMoveToParentViewController(self)

    }
    
    func loadVenues() {
        self.list.removeAll()
        
        let netWrkObj = Networking()
        let baseUrl = "https://api.foursquare.com/"
        let operation = "v2/venues/search?"
        let searchTerm = self.searchTextField.text! as String
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        let dateStr = dateFormatter.stringFromDate(NSDate())
        
        let latitude = 37.3903825
        let longitude = -122.0553348
        
        let urlString = NSString(format: "%@%@query=%@&client_id=%@&client_secret=%@&ll=%f%%2C%f&v=%@", baseUrl,operation,searchTerm,kCLIENTID,kCLIENTSECRET,latitude,longitude ,dateStr)
        
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
                self.loadResultsTableView()
            })
        }
    }
    
    func processJsonData(json: AnyObject) {
        let response = json.valueForKey("response")
        let venues: NSArray = response?.valueForKey("venues") as! NSArray
        
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
            self.list.append(venueObj)
        }
        
        // sort the list
        self.list.sortInPlace({$0.location.distance < $1.location.distance})
    }

    
    @IBAction func editingChanged(sender: AnyObject) {
    }
    
    // MARK: - UITextFieldDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        return true
    }
    
}
