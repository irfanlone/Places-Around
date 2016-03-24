//
//  PhotosViewController.swift
//  Quick-Coffee
//
//  Created by Irfan Lone on 3/21/16.
//  Copyright © 2016 Ilone Labs. All rights reserved.
//

import UIKit

class PhotosViewController: UIViewController {
    
    var dataSource: AbstractCollectionViewDataSource!
    private var photosList : [AnyObject] = []
    var venue : Venue!
    @IBOutlet var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataSource = AbstractCollectionViewDataSource()
        self.collectionView.dataSource = self.dataSource
        
        self.loadPhotos()
        
        // animations
        self.collectionView.transform = CGAffineTransformMakeScale(0.5, 0.5)
        self.collectionView.alpha = 0

    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animateWithDuration(0.5, delay: 0.1, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .CurveEaseIn, animations: { () -> Void in
            
            self.collectionView.transform = CGAffineTransformMakeScale(1, 1)
            self.collectionView.alpha = 1
            
            }, completion: nil )
    }
    
    // Mark: - private

    private func loadPhotos() {
        
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
                print("A JSON parsing error, Details:\n \(error)")
            }
            let response = parsed.valueForKey("response") as! NSDictionary
            let photos = response.valueForKey("photos") as! NSDictionary
            let items = photos.valueForKey("items") as! NSArray
            self.photosList = items as [AnyObject]
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.dataSource.photosList = self.photosList
                self.collectionView.reloadData()
            })
        }
    }

    @IBAction func closePressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
        
}



extension PhotosViewController : UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    // Mark: - UICollectionViewDelegate
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("photosPageView") as! PhotosPageViewController
        vc.photosList = photosList
        vc.currentIndex = indexPath.row
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    // Mark: - UICollectionViewDelegateFlowLayout
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 5, 0, 5)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(119, 117)
    }
    
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 5
    }
    
}
