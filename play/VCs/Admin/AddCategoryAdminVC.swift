//
//  AddCategoryAdminVC.swift
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

class AddCategoryAdminVC: UIViewController
{
    @IBOutlet weak var categoryLabel: UITextField!
    
    @IBOutlet weak var salveaza: UIButton!
    @IBAction func salveaza(_ sender: Any)
    {
        self.salveaza.setTitle("Se conectează..", for: .normal)
        
        let name = self.categoryLabel?.text?.capitalized as! String
        
        let path = reference.child("Categories")
        
        let dict = [name : ["name":name]]
        
        path.updateChildValues(dict)
    }
    
    let reference = Database.database().reference()
    
    override func viewDidLoad() {
        
    }
    
    
    
}
