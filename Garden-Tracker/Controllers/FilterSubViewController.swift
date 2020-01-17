//
//  FilterSubViewController.swift
//  Garden-Tracker
//
//  Created by Hallie Johnson on 1/16/20.
//  Copyright © 2020 Hallie Johnson. All rights reserved.
//

import UIKit

class FilterSubViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var category: String!
    var categoryItems: [String] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        
        // Do any additional setup after loading the view.
        
        categoryItems = makeArray()
    }
    
    func makeArray() -> [String] {
            switch category {
            case "Plant Type":
                return ["Annual", "Bulb", "Evergreen", "Edible", "Grass", "Perennial", "Shrub", "Succulent", "Tree", "Vine"]
            case "Light Needs":
                return ["Full Sun", "Part Sun", "Part Shade", "Full Shade"]
            case "Flowering Season":
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
    
}
