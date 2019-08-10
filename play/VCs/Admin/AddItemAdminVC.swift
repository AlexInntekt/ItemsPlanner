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

class AddItemAdminVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextViewDelegate, UITextFieldDelegate
{
    var displayingCategories=[String]()
    var selectedCategory=""
    
    @IBOutlet weak var itemNameLabel: UITextField!
    
    @IBOutlet weak var categoryPicker: UIPickerView!
    
    @IBOutlet weak var textView: UITextView!
    
    
    @IBOutlet weak var saveItem: UIButton!
    
    @IBAction func saveItem(_ sender: Any)
    {

        let item = Item()
            item.category = selectedCategory
            item.description = self.textView?.text ?? "articol"
            item.name = self.itemNameLabel?.text ?? "descriere articol"
        
        createItem(item: item, byCategory: selectedCategory)
        
        alert(UIVC: self, title: "Succes", message: "Articolul a fost adaugat!")
    }
    
    
    override func viewDidLoad()
    {
        self.textView.delegate = self
        self.itemNameLabel.delegate = self
        self.categoryPicker.delegate = self
        self.categoryPicker.dataSource = self
        
        
        loadCategoriesFromDB()
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
        
        if(!displayingCategories.isEmpty)
        {
            self.selectedCategory=displayingCategories[row]
        }
        
        
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    //dissmis the keyboard after tapping on 'return' from the textField:
    func textFieldShouldReturn(_ titleTextfield: UITextField) -> Bool
    {
        self.view.endEditing(true)
        return true
    }
}
