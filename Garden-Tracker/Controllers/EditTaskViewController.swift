//
//  EditTaskViewController.swift
//  Garden-Tracker
//
//  Created by Hallie Johnson on 1/16/20.
//  Copyright © 2020 Hallie Johnson. All rights reserved.
//

import UIKit
import CoreData

class EditTaskViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextViewDelegate {

    var plants: [Plant] = []
    var activities = [Activity]()
    var activity: Activity?
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet weak var plantMenuTitle: UIButton!
    @IBOutlet weak var tableView: UITableView!
    var selectedPlant : Plant?
    
    // Task menu outlets
    @IBOutlet weak var taskMenuTitle: UIButton!
    @IBOutlet var taskButtons: [UIButton]!
    var task : String! = ""
    
    // Calendar
    @IBOutlet weak var calendarMenuTitle: UIButton!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var saveDateBtn: UIButton!
    var date : Date!
    
    // Notes
    @IBOutlet weak var taskNotes: UITextView!
    
    
    @IBOutlet weak var updateTaskButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        plantMenuTitle.createFloatingActionButton()
        taskMenuTitle.createFloatingActionButton()
        calendarMenuTitle.createFloatingActionButton()
        saveDateBtn.createFloatingActionButton()
        updateTaskButton.createFloatingActionButton()
        
        plantMenuTitle.setTitle("Plant: \(activity?.parentPlant?.name ?? "Select a Plant")", for: .normal)
        selectedPlant = activity?.parentPlant
        taskMenuTitle.setTitle("Task: \(activity?.task ?? "Select a Task")", for: .normal)
        task = activity?.task
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, yyyy"
        calendarMenuTitle.setTitle("Date: \(formatter.string(from:activity!.date!))", for: .normal)
        datePicker.date = (activity?.date)!
        
        if activity?.notes == "" {
            taskNotes.text = "Notes"
            taskNotes.textColor = UIColor.lightGray
        }
        else {
            taskNotes.text = activity?.notes
            taskNotes.textColor = UIColor.black
        }
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 50
        tableView.isHidden = true
        
        taskNotes.delegate = self
    }

    @IBAction func onClickDropBtn(_ sender: UIButton) {
        UIView.animate(withDuration: 0.3) {
            self.tableView.isHidden = !self.tableView.isHidden
            self.view.layoutIfNeeded()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // load data from core data
        loadPlants()

        // reload the table view
        tableView.reloadData()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return plants.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let plant = plants[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = plant.name!

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedPlant = plants[indexPath.row]
        plantMenuTitle.setTitle("Plant: \(plants[indexPath.row].name!)", for: .normal)
        UIView.animate(withDuration: 0.3) {
         self.tableView.isHidden = !self.tableView.isHidden
         self.view.layoutIfNeeded()
         }
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

// MARK: Task Menu

    @IBAction func handleTaskSelection(_ sender: UIButton) {
        menuAction(taskButtons)
    }
    
    @IBAction func taskTapped(_ sender: UIButton) {
        task = sender.currentTitle

        taskMenuTitle.setTitle("Task: \(task!)", for: .normal)
        print(taskMenuTitle.currentTitle!)
        
        taskButtons.forEach { (button) in
            button.isHidden = !button.isHidden }
    }
    
// MARK: Date Picker
    
    @IBAction func selectDateTapped(_ sender: UIButton) {
        datePicker.isHidden = !datePicker.isHidden
        saveDateBtn.isHidden = !saveDateBtn.isHidden
    }
    
    
    @IBAction func saveDateTapped(_ sender: UIButton) {
        datePicker.isHidden = !datePicker.isHidden
        saveDateBtn.isHidden = !saveDateBtn.isHidden
       
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, yyyy"
        calendarMenuTitle.setTitle("Date: \(formatter.string(from:datePicker.date))", for: .normal)

    }
    
    // Notes
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Notes" {
            textView.text = ""
            textView.textColor = UIColor.black
        }
    }
    
    // MARK: Animation function
    
    func menuAction(_ menuButtons: Array<UIButton>) {
        menuButtons.forEach { (button) in
            UIView.animate(withDuration: 0.3, animations: {
                button.isHidden = !button.isHidden
                self.view.layoutIfNeeded()
            })
        }
    }

    // MARK: - Update task
    
    @IBAction func updateTaskBtnTapped(_ sender: UIButton) {
        activity?.task = task
        activity?.date = datePicker.date
        activity?.notes = taskNotes.text!
        activity?.parentPlant = selectedPlant

        //Save the data to coredata
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
    }
}


