//
//  DetailViewController.swift
//  Quick-Coffee
//
//  Created by Irfan Lone on 3/20/16.
//  Copyright © 2016 Ilone Labs. All rights reserved.
//

import UIKit
import MapKit

class DetailViewController: UIViewController {

    var venue : Venue!
    @IBOutlet var name: UILabel!
    @IBOutlet var mapView: MKMapView!
    var annotation : MKPointAnnotation!
    var photosList : [AnyObject] = []
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var seeAllPhotosButton: UIButton!
    @IBOutlet weak var address: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.name.text = self.venue.name
        self.address.text = self.venue.location.address
        let initialLocation = CLLocation(latitude: venue.location.lattitue, longitude: venue.location.longitude)
        self.centerMapOnLocation(initialLocation)
        self.mapView.delegate = self
        self.loadPhotos()
        self.AddBorderToSeeAllPhotosButton()
    }
    
    func AddBorderToSeeAllPhotosButton() {
        self.seeAllPhotosButton.layer.borderWidth = 1.0
        self.seeAllPhotosButton.layer.borderColor = UIColor.darkGrayColor().CGColor
    }
    
    let regionRadius: CLLocationDistance = 700
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
            regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
        annotation = MKPointAnnotation()
        let centerCoordinate = CLLocationCoordinate2DMake(venue.location.lattitue, venue.location.longitude)
        annotation.coordinate = centerCoordinate
        annotation.title = venue.name
        annotation.subtitle = "tap get directions to this place"
        self.mapView .addAnnotation(annotation)
    }
    
    func loadPhotos() {

        let netWrkObj = Networking()
        let baseUrl = "https://api.foursquare.com/v2/venues/"
        let operation = "/photos?"
        let venueId = venue.identifier
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        let dateStr = dateFormatter.stringFromDate(NSDate())
        
        let urlString = NSString(format: "%@%@%@&client_id=%@&client_secret=%@&v=%@", baseUrl,venueId,operation,kCLIENTID,kCLIENTSECRET,dateStr)
        
        let url = NSURL(string: urlString as String)
        netWrkObj.getDataAtUrl(url!) { (success, obj) -> (Void) in
            if success == false {
                return;
            }
            var parsed : AnyObject!
            do {
                parsed = try NSJSONSerialization.JSONObjectWithData(obj.data, options: NSJSONReadingOptions.AllowFragments)
            }
            catch let error as NSError {
                print("A JSON parsing error occurred, here are the details:\n \(error)")
            }
            let response = parsed.valueForKey("response") as! NSDictionary
            let photos = response.valueForKey("photos") as! NSDictionary
            let items = photos.valueForKey("items") as! NSArray
            self.photosList = items as [AnyObject]
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.collectionView.reloadData()
            })
        }
    }

    @IBAction func seeAllPhotosClicked(sender: AnyObject) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("photosStoryboard") as! PhotosViewController
        vc.venue = self.venue
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
}

extension DetailViewController : UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    // Mark:- UICollectionViewDelegate

    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("photosPageView") as! PhotosPageViewController
        vc.photosList = photosList
        vc.currentIndex = indexPath.row
        self.presentViewController(vc, animated: true, completion: nil)
    }

    // Mark: - UICollectionViewDelegateFlowLayout

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 0, 0, 0)
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(122, 122);
    }
    
}

