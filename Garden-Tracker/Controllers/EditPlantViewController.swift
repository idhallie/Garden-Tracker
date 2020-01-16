//
//  EditPlantViewController.swift
//  Garden-Tracker
//
//  Created by Hallie Johnson on 1/15/20.
//  Copyright © 2020 Hallie Johnson. All rights reserved.
//

import UIKit
import CoreData


class EditPlantViewController: UIViewController, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    var plants = [Plant]()
    var plant: Plant?
    
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

    // Add Image
    @IBOutlet weak var imageView: UIImageView!
    // Notes field
    @IBOutlet weak var plantNotes: UITextView!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Populate existing data into fields
        plantName.text = plant?.name
        typeMenuTitle.setTitle("Type: \(plant?.type ?? "Select Plant Type")", for: .normal)
        plantType = plant?.type
        lightMenuTitle.setTitle("Light Needs: \(plant?.light ?? "Select Light Needs")", for: .normal)
        lightNeeds = plant?.light
        floweringMenuTitle.setTitle("Flowering Season: \(plant?.flowering ?? "Select Plant Type")", for: .normal)
        flowering = plant?.flowering
        
        if plant?.notes == "" {
            plantNotes.text = "Notes"
            plantNotes.textColor = UIColor.lightGray
        }
        else {
            plantNotes.text = plant?.notes
            plantNotes.textColor = UIColor.black
        }
        
        if let data = plant?.image as Data? {
            imageView.image = UIImage(data: data)
        }
        
        // set delegates
        plantNotes.delegate = self
        plantName.delegate = self
        plantNotes.delegate = self
        
        self.HideKeyboard()
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
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
    
    
    // MARK: - Update plant
    
    @IBAction func updateBtnTapped(_ sender: Any) {
        plant?.name = plantName.text!
        plant?.type = plantType
        plant?.light = lightNeeds
        plant?.flowering = flowering
        plant?.notes = plantNotes.text!
        
        if let imageData = imageView.image?.jpegData(compressionQuality: 1.0) {
            plant?.image = imageData
        }
        
        //Save the data to coredata
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
    }
    
    func menuAction(_ menuButtons: Array<UIButton>) {
        menuButtons.forEach { (button) in
            UIView.animate(withDuration: 0.3, animations: {
                button.isHidden = !button.isHidden
                self.view.layoutIfNeeded()
            })
        }
    }
    
    @IBAction func addPhotoClicked(_ sender: UIButton) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        
        let actionSheet = UIAlertController(title: "Photo Source", message: "Choose a source", preferredStyle: .actionSheet)
        
        actionSheet.view.layoutIfNeeded()
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action:UIAlertAction) in imagePickerController.sourceType = .camera

            
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
              self.present(imagePickerController, animated: true, completion: nil)
            } else {
                print("Camera not available.")
            }
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action:UIAlertAction) in imagePickerController.sourceType = .photoLibrary
            self.present(imagePickerController, animated: true, completion: nil)
            
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        
        imageView.image = image
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}



