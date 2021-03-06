//
//  TaskDetailViewController.swift
//  Garden-Tracker
//
//  Created by Hallie Johnson on 1/15/20.
//  Copyright © 2020 Hallie Johnson. All rights reserved.
//

import UIKit

class TaskDetailViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var plantNameLabel: UILabel!
    @IBOutlet weak var taskDateLabel: UILabel!
    @IBOutlet weak var notesField: UITextView!
    
    var activity: Activity?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = activity?.task
        plantNameLabel.text = activity?.parentPlant?.name
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-YY"
        taskDateLabel.text = formatter.string(from:(activity?.date!)!)
        
        notesField.text = activity?.notes
        adjustUITextViewHeight(arg: notesField)
    }
    
    @IBAction func editBtnPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "editTaskSegue", sender: activity)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destVC = segue.destination as! EditTaskViewController
        destVC.activity = activity
    }
    
    func adjustUITextViewHeight(arg : UITextView)
    {
        arg.translatesAutoresizingMaskIntoConstraints = true
        arg.sizeToFit()
        arg.isScrollEnabled = false
    }
}
