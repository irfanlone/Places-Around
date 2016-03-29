//
//  VenuesTableViewDataSource.swift
//  Quick-Coffee
//
//  Created by Irfan Lone on 3/25/16.
//  Copyright © 2016 Ilone Labs. All rights reserved.
//

import UIKit

class VenuesTableViewDataSource : NSObject, UITableViewDataSource {
    
    var venues : [Venue] = []
    
    // MARK: - UITableViewDataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return venues.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let reuseIdentifier = "cell";
        let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier, forIndexPath: indexPath) as? VenueTableCell
        let obj = venues[indexPath.row]
        cell?.configureCell(obj.name, _address: obj.location.address, _distance: obj.location.distance)
        return cell!
    }
}