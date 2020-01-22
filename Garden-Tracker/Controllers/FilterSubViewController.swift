//
//  FilterSubViewController.swift
//  Garden-Tracker
//
//  Created by Hallie Johnson on 1/16/20.
//  Copyright © 2020 Hallie Johnson. All rights reserved.
//

import UIKit

struct FilterCriteria {
    var category: String
    var item: String
}
class FilterSubViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var category: String!
    var categoryItems: [String] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        categoryItems = makeArray()
    }
    
    func makeArray() -> [String] {
        switch category {
        case "type":
            return ["Annual", "Bulb", "Evergreen", "Edible", "Grass", "Perennial", "Shrub", "Succulent", "Tree", "Vine"]
        case "light":
            return ["Full Sun", "Part Sun", "Part Shade", "Full Shade"]
        case "flowering":
            return ["Winter", "Spring", "Summer", "Fall", "Not Applicable"]
        default:
            return ["No matches for selected category."]
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SubFilterCell", for: indexPath)
        
        cell.textLabel?.text = categoryItems[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let filterSelection = FilterCriteria(category: category, item: categoryItems[indexPath.row])
        print("From menu: \(filterSelection)")
        
        performSegue(withIdentifier: "FilterHomeSegue", sender: filterSelection)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FilterHomeSegue" {
            let destVC = segue.destination as! HomeViewController
            destVC.filterCriteria = sender as? FilterCriteria
        }
    }
}
