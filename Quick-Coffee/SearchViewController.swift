//
//  SearchViewController.swift
//  Quick-Coffee
//
//  Created by Irfan Lone on 3/25/16.
//  Copyright © 2016 Ilone Labs. All rights reserved.
//

import UIKit
import CoreLocation


class SearchViewController : UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var searchTextField: UITextField!
    var list : [Venue] = []
    var venuesTableVC : VenueTableViewController!
    var currentLocation : CLLocation!
    var tapGR : UITapGestureRecognizer!
    @IBOutlet weak var searchButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchTextField.delegate = self
        let userLoc = UserLocationManager.SharedManager
        userLoc.delegate = self
        self.currentLocation = userLoc.currentLocation
        tapGR = UITapGestureRecognizer(target: self, action: #selector(SearchViewController.handleTap(_:)))
        self.view.addGestureRecognizer(tapGR)
    }
    
    override func viewWillAppear(animated: Bool) {
        navigationController?.navigationBarHidden = true
        super.viewWillAppear(animated)
    }
    
    
    override func viewWillDisappear(animated: Bool) {
        if (navigationController?.topViewController != self) {
            navigationController?.navigationBarHidden = false
        }
        super.viewWillDisappear(animated)
    }
    
    func handleTap(sender: AnyObject) {
        self.searchTextField.resignFirstResponder()
    }
    
    @IBAction func searchPressed(sender: AnyObject) {
        guard self.searchTextField.text != "" else {
            return
        }
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
    
    @IBAction func quickSearchButtonPressed(sender: AnyObject) {
        let button = sender as! UIButton
        var searchTerm : String!
        switch button.tag {
        case 1: searchTerm = "food"
        case 2: searchTerm = "coffee"
        case 3: searchTerm = "drinks"
        case 4: searchTerm = "ice cream"
        case 5: searchTerm = "chocolate"
        case 6: searchTerm = "bar"
        case 7: searchTerm = "bagel"
        case 8: searchTerm = "pan cakes"
        case 9: searchTerm = "park"

        default:
            break
        }
        self.searchTextField.text = searchTerm
        self.searchPressed(self)
    }
    
    @IBAction func test(sender: AnyObject) {
        if let vc = self.venuesTableVC {
            vc.view.removeFromSuperview()
        }
        // add back tap GR
        self.view.addGestureRecognizer(tapGR)
    }
    
    private func loadResultsTableView() {        
        
        // remove Tap GR first.
        self.view.removeGestureRecognizer(tapGR)
        
        venuesTableVC = UIStoryboard(name: "Venues", bundle: nil).instantiateViewControllerWithIdentifier("venuesTable") as! VenueTableViewController
        venuesTableVC.venues = self.list
        var frame = self.view.bounds
        frame.origin.y += 75
        venuesTableVC.view.frame = frame
        self.addChildViewController(venuesTableVC)
        self.view.addSubview(venuesTableVC.view)
        venuesTableVC.didMoveToParentViewController(self)
    }
    
    func loadVenues() {
        
        self.list.removeAll()
        
        venuesController().getVenuesForSearchString(self.searchTextField.text! as String, location: self.currentLocation) { venues -> (Void) in
            self.list = venues
            self.loadResultsTableView()
        }
        
    }
    
    // MARK: - UITextFieldDelegate
    
    @IBAction func editingChanged(sender: AnyObject) {
        if searchTextField.text?.utf16.count  < 1  {
            self.test(self)
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.searchPressed(self)
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        self.searchButton.setTitle("Search", forState: UIControlState.Normal)
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        self.searchButton.setTitle("Cancel", forState: UIControlState.Normal)
    }
    
}

extension SearchViewController : LocationUpdateProtocol {
    
    func locationDidUpdateToLocation(location: CLLocation) {
        self.currentLocation = location
    }
}

