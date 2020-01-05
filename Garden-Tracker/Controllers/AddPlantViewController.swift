//
//  AddPlantViewController.swift
//  Garden-Tracker
//
//  Created by Hallie Johnson on 1/4/20.
//  Copyright © 2020 Hallie Johnson. All rights reserved.
//

import UIKit
import CoreData

class AddPlantViewController: UIViewController {

    @IBOutlet weak var plantName: UITextField!
    @IBOutlet var typeButtons: [UIButton]!
    var plantType : String! = ""
     
    @IBOutlet weak var typeMenuTitle: UIButton!
    
    // Light Stuff
    @IBOutlet weak var lightMenuTitle: UIButton!
    @IBOutlet var lightButtons: [UIButton]!
    var lightNeeds : String! = ""
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func handleTypeSelection(_ sender: UIButton) {
        typeButtons.forEach { (button) in
            UIView.animate(withDuration: 0.3, animations: {
                button.isHidden = !button.isHidden
                self.view.layoutIfNeeded()
            })
        }
        lightMenuTitle.isHidden = !lightMenuTitle.isHidden
    }
    
    
    @IBAction func typeBtnTapped(_ sender: UIButton) {
        plantType = sender.currentTitle!
        typeMenuTitle.setTitle("Type: \(plantType!)", for: .normal)
        
        typeButtons.forEach { (button) in
            button.isHidden = !button.isHidden }
        
        lightMenuTitle.isHidden = !lightMenuTitle.isHidden
        
        }
    
    

    
    @IBAction func addBtnTapped(_ sender: UIButton) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let plant = Plant(context: context)
        plant.name = plantName.text!
        plant.type = plantType
        plant.light = lightNeeds
        
        
        //Save the data to coredata
        
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        navigationController!.popViewController(animated: true)
    }
    
    
    // LIGHT MENU STUFF

    
    @IBAction func handleLightSelection(_ sender: UIButton) {
        lightButtons.forEach {(button) in
            button.isHidden = !button.isHidden
        }
    }
    
        
    @IBAction func lightBtnTapped(_ sender: UIButton) {
        lightNeeds = sender.currentTitle!
        lightMenuTitle.setTitle("Light Needs: \(lightNeeds!)", for: .normal)
        
        lightButtons.forEach { (button) in
            button.isHidden = !button.isHidden }
        
    }
    
}
