//
//  VenueTableCell.swift
//  Quick-Coffee
//
//  Created by Irfan Lone on 3/20/16.
//  Copyright © 2016 Ilone Labs. All rights reserved.
//

import UIKit

class VenueTableCell: UITableViewCell {

    @IBOutlet var name: UILabel!
    @IBOutlet var address: UILabel!
    @IBOutlet var distance: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureCell(_name: String, _address: String, _distance: Float64) {
        self.name?.text = _name
        self.address?.text = _address
        self.distance?.text = "\(_distance/1000) miles away"
    }

}
