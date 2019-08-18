//
//  ModifyCategoryVC.swift
//  play
//
//  Created by Alexandru-Mihai Manolescu on 18/08/2019.
//  Copyright © 2019 Alexandru-Mihai Manolescu. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class ModifyCategoryVC: UIViewController
{

    var currentCategory:(key: String, name: String) = ("","")
    let reference = Database.database().reference()
    
    @IBOutlet weak var newNameTextField: UITextField!
    @IBOutlet weak var currentCategoryName: UILabel!
    
    @IBOutlet weak var back: UIButton!
    @IBAction func back(_ sender: Any)
    {
        self.performSegue(withIdentifier: "back", sender: nil)
    }
    
    @IBOutlet weak var saveButton: UIButton!
    @IBAction func saveButton(_ sender: Any)
    {
        if((newNameTextField.text != nil)&&(newNameTextField.text != ""))
        {
            let newName = newNameTextField.text?.capitalized
            
            let path = reference.child("Categories").child(currentCategory.key)
            
            path.updateChildValues(["name":newName])
            
            let pathToChange = reference.child("Bookings")
            
            let query = reference.child("Bookings")
                .observeSingleEvent(of: .value) { (pack) in
                    
                    for booking in pack.children.allObjects as! [DataSnapshot]{
                        
                        let its_category_id = booking.childSnapshot(forPath: "categoryId").value as! String
                        
                        let key = booking.key as! String
                        
                        if(its_category_id==self.currentCategory.key)
                        {
                            self.reference.child("Bookings").child(key).updateChildValues(["categoryName":newName])
                        }
                        
                    }
            }
            
            alert(UIVC: self, title: "Status", message: "Modificarea a fost trimisă către server.")
            
        }
        else
        {
            alert(UIVC: self, title: "Invalid", message: "Introduceti un text în câmpul de mai sus pentru o redenumire!")
        }
        
    }
    
    
    override func viewDidLoad()
    {
        self.currentCategoryName.text=currentCategory.name
    }
    
   
}
