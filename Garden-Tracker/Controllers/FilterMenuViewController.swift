//
//  FilterMenuViewController.swift
//  Garden-Tracker
//
//  Created by Hallie Johnson on 1/16/20.
//  Copyright © 2020 Hallie Johnson. All rights reserved.
//

import UIKit

class FilterMenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let categories = ["Plant Type", "Light Needs", "Flowering Season"]

    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
    }
    
    
    @IBAction func cancelBtnTapped(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FilterCell", for: indexPath)
        
        cell.textLabel?.text = categories[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let category = categories[indexPath.row]
        performSegue(withIdentifier: "FilterSubSegue", sender: category)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FilterSubSegue" {
            let destVC = segue.destination as! FilterSubViewController
            destVC.category = sender as? String
        }
    }

}
