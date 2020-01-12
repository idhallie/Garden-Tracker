//
//  TaskLogViewController.swift
//  Garden-Tracker
//
//  Created by Hallie Johnson on 1/9/20.
//  Copyright © 2020 Hallie Johnson. All rights reserved.
//

import UIKit

class TaskLogViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    @IBOutlet weak var tableView: UITableView!
    var activities : [Activity] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadActivites()
        
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let activity = activities[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ActivityCell") as! ActivityCell
        cell.setActivity(activity: activity)

        return cell
    }
    
    func loadActivites() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
        do {
        activities = try context.fetch(Activity.fetchRequest())
        } catch {
            print("Error loading activities: \(error)")
        }
    }

}
