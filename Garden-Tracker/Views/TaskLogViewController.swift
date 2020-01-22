//
//  TaskLogViewController.swift
//  Garden-Tracker
//
//  Created by Hallie Johnson on 1/9/20.
//  Copyright © 2020 Hallie Johnson. All rights reserved.
//

import UIKit
import CoreData

class TaskLogViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    @IBOutlet weak var tableView: UITableView!
    var activities : [Activity] = []
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
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
    
    @IBAction func unwindToTaskLog(_ sender: UIStoryboardSegue) {}
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let activity = activities[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ActivityCell") as! ActivityCell
        cell.setActivity(activity: activity)

        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {

        if editingStyle == .delete {
            let activity = activities[indexPath.row]
            context.delete(activity)
            (UIApplication.shared.delegate as! AppDelegate).saveContext()

            do {
               activities = try context.fetch(Activity.fetchRequest())
            }
            catch {
                print("Fetching failed \(error)")
            }
        }
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let activity = activities[indexPath.row]
        performSegue(withIdentifier: "taskDetailSegue", sender: activity)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "taskDetailSegue" {
            let destVC = segue.destination as! TaskDetailViewController
            destVC.activity = sender as? Activity
        }
    }
    
    func loadActivites() {
        let fetchRequest = NSFetchRequest<Activity>(entityName: "Activity")
        let sort = NSSortDescriptor(key: #keyPath(Activity.date), ascending: false)
        fetchRequest.sortDescriptors = [sort]
        
        do {
            activities = try context.fetch(fetchRequest)
        } catch {
            print("Error loading activities: \(error)")
        }
    }
}
