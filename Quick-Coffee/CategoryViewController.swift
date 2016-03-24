//
//  CategoryViewController.swift
//  Quick-Coffee
//
//  Created by Irfan Lone on 3/24/16.
//  Copyright © 2016 Ilone Labs. All rights reserved.
//

import UIKit

protocol DismissedCategoryViewProtocol {
    func categoryViewDismissed(_: ItemCategory)
}

enum ItemCategory : Int {
    
    case CoffeeShops = 1
    case Bakery = 2
    case Desert = 3
    case IndianFood = 4
    case MexicanFood = 5
    case MiddleEasternFood = 6
    case ChineseFood = 7
    case JapaneseFood = 8
    case Bar = 9
    case NightLife = 10
    
    
    func stringValue(item: ItemCategory) -> String {
        var output: String!
        switch item {
            case .CoffeeShops: output = "4bf58dd8d48988d1e0931735"
            case .Bakery: output = "4bf58dd8d48988d16a941735"
            case .Desert: output = "4bf58dd8d48988d1d0941735"
            case .IndianFood: output = "4bf58dd8d48988d10f941735"
            case .MexicanFood: output = "4bf58dd8d48988d1c1941735"
            case .MiddleEasternFood: output = "4bf58dd8d48988d115941735"
            case .ChineseFood: output = "4bf58dd8d48988d145941735"
            case .JapaneseFood: output = "4bf58dd8d48988d111941735"
            case .Bar: output = "4bf58dd8d48988d116941735"
            case .NightLife:output = "4bf58dd8d48988d11f941735"
        }
        return output
    }
    
    static let allValues = [
        CoffeeShops,
        Bakery,
        Desert,
        IndianFood,
        MexicanFood,
        MiddleEasternFood,
        ChineseFood,
        JapaneseFood,
        Bar,
        NightLife
    ]
}


class CategoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var selectedCategory : ItemCategory!
    var delegate : DismissedCategoryViewProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    // MARK: - UITableViewDataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ItemCategory.allValues.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let reuseIdentifier = "cell";
        let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier, forIndexPath: indexPath)
        self.configure(cell: cell, indexPath: indexPath)
        return cell
    }
    
    
    private func configure(cell cell: UITableViewCell, indexPath: NSIndexPath) {
        if indexPath.row == self.selectedCategory.rawValue {
            cell.accessoryType = .Checkmark
        } else {
            cell.accessoryType = .None
        }
        switch indexPath.row {
        case 1: cell.textLabel?.text = "Coffee Shops"
        case 2: cell.textLabel?.text = "Bakery"
        case 3: cell.textLabel?.text = "Desert"
        case 4: cell.textLabel?.text = "Indian Food"
        case 5: cell.textLabel?.text = "Mexican Food"
        case 6: cell.textLabel?.text = "Middle Eastern Food"
        case 7: cell.textLabel?.text = "Chinese Food"
        case 8: cell.textLabel?.text = "Japanese Food"
        case 8: cell.textLabel?.text = "Bars"
        case 10: cell.textLabel?.text = "Nightlife"
        default: break;
        }
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.row {
            case 1: selectedCategory = .CoffeeShops
            case 2: selectedCategory = .Bakery
            case 3: selectedCategory = .Desert
            case 4: selectedCategory = .IndianFood
            case 5: selectedCategory = .MexicanFood
            case 6: selectedCategory = .MiddleEasternFood
            case 7: selectedCategory = .ChineseFood
            case 8: selectedCategory = .JapaneseFood
            case 9: selectedCategory = .Bar
            case 10: selectedCategory = .NightLife
            default: break
        }
        tableView.reloadData()
    }

    @IBAction func close(sender: AnyObject) {
        self.delegate.categoryViewDismissed(selectedCategory)
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}
