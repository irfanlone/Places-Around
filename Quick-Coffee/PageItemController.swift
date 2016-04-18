//
//  PageItemController.swift
//  Quick-Coffee
//
//  Created by Irfan Lone on 3/22/16.
//  Copyright © 2016 Ilone Labs. All rights reserved.
//

import UIKit

protocol dismissPageViewControllerProtocol {
    func dismissPageViewController()
}

class PageItemController: UIViewController {
    
    var delegate : dismissPageViewControllerProtocol?

    @IBOutlet var imageView: UIImageView!
    var itemIndex: Int = 0
    var imageUrl: String!
    var activityIndicator : UIActivityIndicatorView!
    
    override func loadView() {
        super.loadView()
        self.activityIndicator = UIActivityIndicatorView(activityIndicatorStyle:.WhiteLarge)
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
        
        let url = NSURL(string: imageUrl)
        Networking().getDataAtUrl(url!) { (success, obj) -> (Void) in
            guard success == true else {
                return
            }
            if let image = UIImage(data: obj.data) {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.imageView.image = image
                    self.activityIndicator.stopAnimating()
                })
            }
        }
    }
    
    @IBAction func closePressed(sender: AnyObject) {
        self.delegate?.dismissPageViewController()
    }

}
