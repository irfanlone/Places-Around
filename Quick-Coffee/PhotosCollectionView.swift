//
//  PhotosCollectionView.swift
//  Quick-Coffee
//
//  Created by Irfan Lone on 3/21/16.
//  Copyright © 2016 Ilone Labs. All rights reserved.
//

import UIKit

extension DetailViewController : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    // Mark: - UICollectionView Datasource
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1;
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.photosList.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let reuseIdentifier = "cell"
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! PhotosCell
        let photoItem = self.photosList[indexPath.row] as! NSDictionary
        let prefix = photoItem.valueForKey("prefix") as! String
        let suffix = photoItem.valueForKey("suffix") as! String
        let imageSize = "100x100"
        let imageUrl = NSString(format: "%@%@%@", prefix, imageSize, suffix)
        
        let url = NSURL(string: imageUrl as String)
        let netWrkObj = Networking()
        netWrkObj.getDataAtUrl(url!) { (success, obj) -> (Void) in
            if success == false {
                return;
            }
            if let image = UIImage(data: obj.data) {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    let updatedCell = self.collectionView .cellForItemAtIndexPath(indexPath) as! PhotosCell
                    updatedCell.imageView.image = image
                })
            }
        }
        return cell
    }

    // Mark:- UICollectionViewDelegate
    
    
    
    // Mark: - UICollectionViewDelegateFlowLayout
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 0, 0, 0)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(122, 122);
    }

}