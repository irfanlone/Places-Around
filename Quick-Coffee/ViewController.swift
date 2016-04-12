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
    var currentLocation : CLLocation!
    var selectedIndexPath : NSIndexPath!
    var activityIndicator : UIActivityIndicatorView!
    var category : ItemCategory!
    var venuesTableVC : VenueTableViewController!
    
    @IBOutlet weak var container: UIView!
    
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
        
        navigationController?.hidesBarsOnSwipe = true
        
        let userLoc = UserLocationManager.SharedManager
        userLoc.delegate = self
        self.title = "Places"
        
        let rightButton : UIBarButtonItem = UIBarButtonItem(title: "Filter", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(ViewController.loadCategorySelectionView))
        self.navigationItem.rightBarButtonItem = rightButton
        
        let dispatchTime: dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW, Int64(0.1 * Double(NSEC_PER_SEC)))
        dispatch_after(dispatchTime, dispatch_get_main_queue(), {
            self.loadCategorySelectionView()
        })
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func loadCategorySelectionView() {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("categoryStoryboard") as! CategoryViewController
        vc.delegate = self
        var selectedCategory : ItemCategory = .CoffeeShops
        if let row = category  {
            selectedCategory = row
        }
        vc.selectedCategory = selectedCategory
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    func loadTableViewController() {
        venuesTableVC = UIStoryboard(name: "Venues", bundle: nil).instantiateViewControllerWithIdentifier("venuesTable") as! VenueTableViewController
        venuesTableVC.venues = self.list
        self.addChildViewController(venuesTableVC)
        self.container.addSubview(venuesTableVC.view)
        venuesTableVC.didMoveToParentViewController(self)
    }
    
    func loadVenues() {
        
        self.list.removeAll()
        
        venuesController().getVenuesForCategory(self.category, location: self.currentLocation) { venues -> (Void) in
            self.list = venues
            self.activityIndicator.stopAnimating()
            self.loadTableViewController()
        }
    }
    

}

extension ViewController : LocationUpdateProtocol {
    
    func locationDidUpdateToLocation(location: CLLocation) {
        self.currentLocation = location
    }
}

extension ViewController : DismissedCategoryViewProtocol {
    
    func categoryViewDismissed(category: ItemCategory) {
        self.category = category
        self.loadVenues()
    }
}


