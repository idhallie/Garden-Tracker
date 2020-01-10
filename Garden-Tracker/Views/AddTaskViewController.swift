//
//  AddTaskViewController.swift
//  Garden-Tracker
//
//  Created by Hallie Johnson on 1/9/20.
//  Copyright © 2020 Hallie Johnson. All rights reserved.
//

import UIKit
import CoreData

class AddTaskViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    @IBOutlet weak var plantMenuTitle: UIButton!
    @IBOutlet weak var tblView: UITableView!
    
    var plants: [Plant] = []
    
    // let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tblView.dataSource = self
        tblView.delegate = self
        tblView.rowHeight = 50
        tblView.isHidden = true
    }

    @IBAction func onClickDropBtn(_ sender: UIButton) {
        UIView.animate(withDuration: 0.3) {
            self.tblView.isHidden = !self.tblView.isHidden
            self.view.layoutIfNeeded()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // load data from core data
        loadPlants()

        // reload the table view
        tblView.reloadData()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return plants.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "plantCell", for: indexPath)
//
//
//        cell.textLabel?.text = plants[indexPath.row].name
//
//        return cell
        
        let plantCell = UITableViewCell()
        
         let plant = plants[indexPath.row]
         plantCell.textLabel?.text = plant.name!

         return plantCell
    }
    
    func loadPlants() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<Plant>(entityName: "Plant")
        let sort = NSSortDescriptor(key: #keyPath(Plant.name), ascending: true)
        fetchRequest.sortDescriptors = [sort]
            do {
               plants = try context.fetch(fetchRequest)
            }
            catch {
                print("Fetching failed \(error)")
            }
        }
    }

