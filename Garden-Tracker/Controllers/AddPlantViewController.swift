//
//  AddPlantViewController.swift
//  Garden-Tracker
//
//  Created by Hallie Johnson on 1/4/20.
//  Copyright © 2020 Hallie Johnson. All rights reserved.
//

import UIKit

class AddPlantViewController: UIViewController {

    @IBOutlet weak var plantName: UITextField!
    @IBOutlet var typeButtons: [UIButton]!
         var plantType : String! = ""
     
    @IBOutlet weak var typeMenuTitle: UIButton!
    
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
        // lightMenu.isHidden = !lightMenu.isHidden
    }
    
    
    @IBAction func typeBtnTapped(_ sender: UIButton) {
        plantType = sender.currentTitle!
        typeMenuTitle.setTitle("Type: \(plantType!)", for: .normal)
        
        typeButtons.forEach { (button) in
            button.isHidden = !button.isHidden }
        
        // lightMenu.isHidden = !lightMenu.isHidden
        
        }
        
    
    @IBAction func addBtnTapped(_ sender: UIButton) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let plant = Plant(context: context)
        plant.name = plantName.text!
        plant.type = plantType
        
        
        //Save the data to coredata
        
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        navigationController!.popViewController(animated: true)
    }
    
    
    
}
