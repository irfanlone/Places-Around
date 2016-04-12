//
//  Helper.swift
//  Quick-Coffee
//
//  Created by Irfan Lone on 4/12/16.
//  Copyright © 2016 Ilone Labs. All rights reserved.
//

import Foundation

func dateStringForCurrentDate() -> String! {
    
    let dateFormatter = NSDateFormatter()
    dateFormatter.dateFormat = "yyyyMMdd"
    return dateFormatter.stringFromDate(NSDate())
    
}
