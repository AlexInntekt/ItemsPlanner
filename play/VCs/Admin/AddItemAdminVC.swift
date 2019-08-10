//
//  AddItemAdminVC.swift
//  play
//
//  Created by Alexandru-Mihai Manolescu on 10/08/2019.
//  Copyright © 2019 Alexandru-Mihai Manolescu. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class AddItemAdminVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource
{
    var displayingCategories=[String]()
    var selectedCategory=""
    
    @IBOutlet weak var itemNameLabel: UITextField!
    
    @IBOutlet weak var categoryPicker: UIPickerView!
    
    @IBOutlet weak var textView: UITextView!
    
    
    @IBOutlet weak var saveItem: UIButton!
    
    @IBAction func saveItem(_ sender: Any)
    {
        let name=self.itemNameLabel?.text
        let category=selectedCategory
        print(category)
    }
    
    
    override func viewDidLoad()
    {
        loadCategoriesFromDB()
        
        self.categoryPicker.delegate = self
        self.categoryPicker.dataSource = self
    }
    
    func loadCategoriesFromDB()
    {
        displayingCategories.removeAll()
        
        let ref = Database.database().reference().child("Categories")
        
        ref.observeSingleEvent(of: .value) { (allCategories) in
            
            for category in allCategories.children.allObjects as! [DataSnapshot]{
                self.displayingCategories.append(category.key)
                
                print(category.key)
            }

            self.categoryPicker.reloadAllComponents()
            
            self.selectedCategory=self.displayingCategories[0]
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 40
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return displayingCategories.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return displayingCategories[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        self.selectedCategory=displayingCategories[row]
        
    }
    
    
}
