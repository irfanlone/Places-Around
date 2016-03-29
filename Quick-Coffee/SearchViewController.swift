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
    var list : [Venue] = []
    var venuesTableVC : VenueTableViewController!
    
    @IBOutlet weak var searchButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.searchTextField.delegate = self
    }
    
    @IBAction func searchPressed(sender: AnyObject) {
        let title = self.searchButton.titleLabel?.text
        if title == "Cancel" {
            self.test(self)
            self.searchButton.setTitle("Search", forState: UIControlState.Normal)
            self.searchTextField.text = ""
        } else {
            self.loadVenues()
            self.searchButton.setTitle("Cancel", forState: UIControlState.Normal)
        }
        self.searchTextField.resignFirstResponder()
    }
    
    
    @IBAction func test(sender: AnyObject) {
        self.venuesTableVC.view.removeFromSuperview()
    }
    
    private func loadResultsTableView() {        
        
        venuesTableVC = UIStoryboard(name: "Venues", bundle: nil).instantiateViewControllerWithIdentifier("venuesTable") as! VenueTableViewController
        venuesTableVC.venues = self.list
        var frame = self.view.bounds
        frame.origin.y += 100
        venuesTableVC.view.frame = frame
        self.addChildViewController(venuesTableVC)
        self.view.addSubview(venuesTableVC.view)
        
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
            self.list = Venue.processJsonDataToVenues(parsed)
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.loadResultsTableView()
            })
        }
    }
    
    // MARK: - UITextFieldDelegate
    
    @IBAction func editingChanged(sender: AnyObject) {
        if searchTextField.text?.utf16.count  < 1  {
            self.test(self)
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        self.searchButton.setTitle("Search", forState: UIControlState.Normal)
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        self.searchButton.setTitle("Cancel", forState: UIControlState.Normal)
    }
    
}
