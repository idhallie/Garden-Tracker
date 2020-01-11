//
//  AddPlantViewController.swift
//  Garden-Tracker
//
//  Created by Hallie Johnson on 1/4/20.
//  Copyright © 2020 Hallie Johnson. All rights reserved.
//

import UIKit
import CoreData

class AddPlantViewController: UIViewController, UITextViewDelegate {

    var plants = [Plant]()
    @IBOutlet weak var plantName: UITextField!
    
    // Type menu outlets
    @IBOutlet weak var typeMenuTitle: UIButton!
    @IBOutlet var typeButtons: [UIButton]!
    var plantType : String! = ""
    
    // Light menu outlets
    @IBOutlet weak var lightMenuTitle: UIButton!
    @IBOutlet var lightButtons: [UIButton]!
    var lightNeeds : String! = ""
    
    // Flowering menu outlets
    @IBOutlet weak var floweringMenuTitle: UIButton!
    @IBOutlet var floweringButtons: [UIButton]!
    var flowering : String! = ""
    
    // Notes field
    @IBOutlet weak var plantNotes: UITextView!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        plantNotes.text = "Notes"
        plantNotes.textColor = UIColor.lightGray
        plantNotes.delegate = self
    }
    
    // TYPE MENU
    @IBAction func handleTypeSelection(_ sender: UIButton) {
        menuAction(typeButtons)
    }
    
    @IBAction func typeBtnTapped(_ sender: UIButton) {
        plantType = sender.currentTitle!
        typeMenuTitle.setTitle("Type: \(plantType!)", for: .normal)
        
        menuAction(typeButtons)
        }
    
    // LIGHT MENU
    @IBAction func handleLightSelection(_ sender: UIButton) {
        menuAction(lightButtons)
    }
        
    @IBAction func lightBtnTapped(_ sender: UIButton) {
        lightNeeds = sender.currentTitle!
        lightMenuTitle.setTitle("Light Needs: \(lightNeeds!)", for: .normal)
        
        menuAction(lightButtons)
    }
    
    // FLOWERING MENU
    
    @IBAction func handleFloweringSelection(_ sender: UIButton) {
        menuAction(floweringButtons)
    }
    
    @IBAction func floweringBtnTapped(_ sender: UIButton) {
        flowering = sender.currentTitle!
        floweringMenuTitle.setTitle("Flowering Season: \(flowering!)", for: .normal)
        
        menuAction(floweringButtons)
    }
    
    // Notes
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Notes" {
            textView.text = ""
            textView.textColor = UIColor.black
        }
    }
    
    
    // MARK: Add new plant
    @IBAction func addBtnTapped(_ sender: UIButton) {

        
        let newPlant = Plant(context: context)
        newPlant.name = plantName.text!
        newPlant.type = plantType
        newPlant.light = lightNeeds
        newPlant.flowering = flowering
        newPlant.notes = plantNotes.text!
        
        self.plants.append(newPlant)
        //Save the data to coredata
        
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        navigationController!.popViewController(animated: true)
    }
    
    
    func menuAction(_ menuButtons: Array<UIButton>) {
        menuButtons.forEach { (button) in
            UIView.animate(withDuration: 0.3, animations: {
                button.isHidden = !button.isHidden
                self.view.layoutIfNeeded()
            })
        }
    }
}
