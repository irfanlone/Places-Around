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
    @IBOutlet weak var seeAllPhotos: UIButton!
    @IBOutlet weak var Menu: UILabel!
    @IBOutlet weak var Website: UILabel!
    @IBOutlet weak var phoneNumber: UILabel!
    var dataSource : AbstractCollectionViewDataSource!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataSource = AbstractCollectionViewDataSource()
        self.collectionView.dataSource = dataSource
        
        self.name.text = self.venue.name
        self.address.text = self.venue.location.address
        let initialLocation = CLLocation(latitude: venue.location.lattitue, longitude: venue.location.longitude)
        self.centerMapOnLocation(initialLocation)
        self.mapView.delegate = self
        self.loadPhotos()
        self.AddBorderToSeeAllPhotosButton()
        
        self.preAnimationTransformation()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animateWithDuration(0.5, delay: 0.1, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .CurveEaseIn, animations: { () -> Void in
            
            self.animationTransformation()
            
            }, completion: nil )
    }

    func preAnimationTransformation() {
        self.mapView.alpha = 0
        self.mapView.transform = CGAffineTransformMakeScale(0.5, 0.5)
        self.collectionView.alpha = 0
        self.collectionView.transform = CGAffineTransformMakeScale(0.5, 0.5)
        self.name.transform = CGAffineTransformMakeScale(0.5, 0.5)
        self.name.alpha = 0
        self.address.transform = CGAffineTransformMakeScale(0.5, 0.5)
        self.address.alpha = 0
        self.Menu.transform = CGAffineTransformMakeScale(0.5, 0.5)
        self.Menu.alpha = 0
        self.Website.transform = CGAffineTransformMakeScale(0.5, 0.5)
        self.Website.alpha = 0
        self.phoneNumber.transform = CGAffineTransformMakeScale(0.5, 0.5)
        self.phoneNumber.alpha = 0
        self.seeAllPhotos.transform = CGAffineTransformMakeScale(0.5, 0.5)
        self.seeAllPhotos.alpha = 0
    }
    
    func animationTransformation() {
        self.mapView.transform = CGAffineTransformMakeScale(1, 1)
        self.mapView.alpha = 1
        self.collectionView.transform = CGAffineTransformMakeScale(1, 1)
        self.collectionView.alpha = 1
        self.name.transform = CGAffineTransformMakeScale(1, 1)
        self.name.alpha = 1
        self.address.transform = CGAffineTransformMakeScale(1, 1)
        self.address.alpha = 1
        self.Menu.transform = CGAffineTransformMakeScale(1, 1)
        self.Menu.alpha = 1
        self.Website.transform = CGAffineTransformMakeScale(1, 1)
        self.Website.alpha = 1
        self.phoneNumber.transform = CGAffineTransformMakeScale(1, 1)
        self.phoneNumber.alpha = 1
        self.seeAllPhotos.transform = CGAffineTransformMakeScale(1, 1)
        self.seeAllPhotos.alpha = 1
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
    
    // Mark:- private

    private func loadPhotos(downloader: DownloadPhotos = DownloadPhotos()) {

        downloader.getPhotoForVenue(venue.identifier) { (photosList) -> (Void) in
            self.photosList = photosList
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.dataSource.photosList = self.photosList
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

