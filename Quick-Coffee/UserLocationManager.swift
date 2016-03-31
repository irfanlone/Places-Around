//
//  UserLocationManager.swift
//  Quick-Coffee
//
//  Created by Irfan Lone on 3/30/16.
//  Copyright © 2016 Ilone Labs. All rights reserved.
//


import MapKit

protocol LocationUpdateProtocol {
    func locationDidUpdateToLocation(location : CLLocation)
}


/// Notification on update of location. UserInfo contains CLLocation for key "location"
let kLocationDidChangeNotification = "LocationDidChangeNotification"

class UserLocationManager: NSObject, CLLocationManagerDelegate {
    
    static let SharedManager = UserLocationManager()
    
    private var locationManager = CLLocationManager()
    
    var currentLocation : CLLocation?
    
    var delegate : LocationUpdateProtocol!
    
    private override init () {
        super.init()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.distanceFilter = kCLLocationAccuracyHundredMeters
        locationManager.requestAlwaysAuthorization()
        self.locationManager.startUpdatingLocation()
    }
    
    // MARK: - CLLocationManagerDelegate
    
    func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation) {
        currentLocation = newLocation
        let userInfo : NSDictionary = ["location" : currentLocation!]
        
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            self.delegate.locationDidUpdateToLocation(self.currentLocation!)
            NSNotificationCenter.defaultCenter().postNotificationName(kLocationDidChangeNotification, object: self, userInfo: userInfo as [NSObject : AnyObject])
        }
    }
    
}



