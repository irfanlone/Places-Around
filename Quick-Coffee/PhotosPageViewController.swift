//
//  PhotosPageViewController.swift
//  Quick-Coffee
//
//  Created by Irfan Lone on 3/22/16.
//  Copyright © 2016 Ilone Labs. All rights reserved.
//

import UIKit

class PhotosPageViewController: UIViewController, UIPageViewControllerDataSource, dismissPageViewControllerProtocol {
    
    
    var photosList : [AnyObject] = []
    var currentIndex : Int!
    private var pageViewController: UIPageViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.createPageViewController()
        self.setupPageControl()
    }

    private func createPageViewController() {
        
        let pageController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("pageController") as! UIPageViewController
        pageController.dataSource = self
        if photosList.count > 0 {
            let firstController = getItemController(currentIndex)!
            let startingViewControllers: NSArray = [firstController]
            pageController.setViewControllers(startingViewControllers as? [UIViewController], direction: UIPageViewControllerNavigationDirection.Forward, animated: false, completion: nil)
        }
        
        pageViewController = pageController
        addChildViewController(pageViewController!)
        self.view.addSubview(pageViewController!.view)
        pageViewController!.didMoveToParentViewController(self)
    }
    
    private func setupPageControl() {
        let appearance = UIPageControl.appearance()
        appearance.pageIndicatorTintColor = UIColor.grayColor()
        appearance.currentPageIndicatorTintColor = UIColor.whiteColor()
        appearance.backgroundColor = UIColor.darkGrayColor()
    }
    
    private func getItemController(itemIndex: Int) -> PageItemController? {
        if itemIndex < photosList.count {
            let pageItemController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("pageItem") as! PageItemController
            pageItemController.itemIndex = itemIndex
            pageItemController.delegate = self
            
            let photoItem = self.photosList[itemIndex] as! NSDictionary
            
            var prefix : String! = ""
            if let pfx = photoItem.valueForKey("prefix") {
                prefix = pfx as! String
            }
            
            var suffix : String! = ""
            if let sfx = photoItem.valueForKey("suffix") {
                suffix = sfx as! String
            }
            
            let imageSize = "400x400"
            let imageUrl = NSString(format: "%@%@%@", prefix, imageSize, suffix)

            pageItemController.imageUrl = imageUrl as String
            return pageItemController
        }
        return nil
    }

    // MARK: - UIPageViewControllerDataSource

    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        let itemController = viewController as! PageItemController
        if itemController.itemIndex > 0 {
            return getItemController(itemController.itemIndex-1)
        }
        return nil
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        let itemController = viewController as! PageItemController
        if itemController.itemIndex+1 < photosList.count {
            return getItemController(itemController.itemIndex+1)
        }
        return nil
    }
    
    // MARK: - dismissPageViewControllerProtocol
    
    func dismissPageViewController() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}
