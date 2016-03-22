//
//  PhotosCollectionView.swift
//  Quick-Coffee
//
//  Created by Irfan Lone on 3/21/16.
//  Copyright © 2016 Ilone Labs. All rights reserved.
//

import UIKit

extension DetailViewController : UICollectionViewDataSource {

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
        
        var prefix : String! = ""
        if let pfx = photoItem.valueForKey("prefix") {
            prefix = pfx as! String
        }
        
        var suffix : String! = ""
        if let sfx = photoItem.valueForKey("suffix") {
            suffix = sfx as! String
        }

        let imageSize = "100x100"
        let imageUrl = NSString(format: "%@%@%@", prefix, imageSize, suffix)
        
        let url = NSURL(string: imageUrl as String)
        let netWrkObj = Networking()
        netWrkObj.getDataAtUrl(url!) { (success, obj) -> (Void) in
            guard success == true else {
                return;
            }
            if let image = UIImage(data: obj.data) {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    guard let updatedCell = self.collectionView.cellForItemAtIndexPath(indexPath) else {
                        return
                    }
                    let newCell = updatedCell as! PhotosCell
                    newCell.imageView.image = image
                })
            }
        }
        return cell
    }
    
}