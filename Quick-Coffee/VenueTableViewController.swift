//
//  VenueTableViewController.swift
//  Quick-Coffee
//
//  Created by Irfan Lone on 3/26/16.
//  Copyright © 2016 Ilone Labs. All rights reserved.
//

import UIKit

class VenueTableViewController : UIViewController {
    
    var venues : [Venue] = []
    var selectedIndexPath : NSIndexPath!
    var dataSource : VenuesTableViewDataSource!
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = VenuesTableViewDataSource()
        self.dataSource.venues = venues
        self.tableView.dataSource = self.dataSource
        self.animateTable()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        //self.animateTable()
    }
    
    func animateTable() {
        tableView.reloadData()
        let cells = tableView.visibleCells
        //let tableHeight: CGFloat = tableView.bounds.size.height
        let tableWidth : CGFloat = tableView.bounds.size.width
        
        var indx = 0
        for i in cells {
            let cell: UITableViewCell = i as UITableViewCell
            if indx%2 == 0 {
                cell.transform = CGAffineTransformMakeTranslation(-tableWidth, 0)
            } else {
                cell.transform = CGAffineTransformMakeTranslation(tableWidth, 0)
            }
            indx++
        }
        
        var index = 0
        for a in cells {
            let cell: UITableViewCell = a as UITableViewCell
            UIView.animateWithDuration(2.5, delay: 0.1 * Double(index), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: [], animations: {
                cell.transform = CGAffineTransformMakeTranslation(0, 0);
                }, completion: nil)
            index += 1
        }
    }
}


extension VenueTableViewController :  UITableViewDelegate {
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.selectedIndexPath = indexPath;
        self .performSegueWithIdentifier("detail", sender: self)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "detail" {
            let dvc = segue.destinationViewController as! DetailViewController
            dvc.venue = venues[self.selectedIndexPath.row]
        }
    }
    
}