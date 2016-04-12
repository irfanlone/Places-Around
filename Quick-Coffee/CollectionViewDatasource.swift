//
//  AbstractDatasource.swift
//  Quick-Coffee
//
//  Created by Irfan Lone on 3/24/16.
//  Copyright © 2016 Ilone Labs. All rights reserved.
//

import UIKit

class AbstractCollectionViewDataSource: NSObject, UICollectionViewDataSource {
    
    var photosList : [AnyObject] = []
    
    // MARK: - UICollectionViewDataSource

    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let reuseIdentifier = "cell"
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! PhotosCell
        self.configure(cell: cell, collectionView: collectionView, indexPath: indexPath)
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.photosList.count
    }
    
    // MARK: - private
    
    private func configure(cell cell: PhotosCell, collectionView: UICollectionView, indexPath: NSIndexPath) {
        
        cell.imageView.image = UIImage()
        
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
        Networking().getDataAtUrl(url!) { (success, obj) -> (Void) in
            guard success == true else {
                return;
            }
            if let image = UIImage(data: obj.data) {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    guard let updatedCell = collectionView.cellForItemAtIndexPath(indexPath) else {
                        return
                    }
                    let newCell = updatedCell as! PhotosCell
                    newCell.imageView.image = image
                })
            }
        }
    }
    
}