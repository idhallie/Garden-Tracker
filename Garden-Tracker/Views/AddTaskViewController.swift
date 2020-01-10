//
//  AddTaskViewController.swift
//  Garden-Tracker
//
//  Created by Hallie Johnson on 1/9/20.
//  Copyright © 2020 Hallie Johnson. All rights reserved.
//

import UIKit
import CoreData

class AddTaskViewController: UIViewController {

    
    @IBOutlet weak var plantMenuTitle: UIButton!
    @IBOutlet weak var tblView: UITableView!
    
    var plants: [Plant] = []
    var plantList = ["Rose", "Daisy", "Sunflower"]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        tblView.isHidden = true
    }

    @IBAction func onClickDropBtn(_ sender: UIButton) {
        UIView.animate(withDuration: 0.3) {
            self.tblView.isHidden = !self.tblView.isHidden
            self.view.layoutIfNeeded()
        }
    }
}

extension AddTaskViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return plantList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "plantCell", for: indexPath)
        
        
        
        cell.textLabel?.text = plantList[indexPath.row]

        return cell
    }
    
    
}
