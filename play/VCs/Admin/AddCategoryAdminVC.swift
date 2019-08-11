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
        
        path.updateChildValues(dict) { (error, reference) in
            if(error==nil)
            {
                //alert(UIVC: self, title: "Adăugare cu succes", message: "Categoria a fost adăugată!")
                
                let title = "Adăugare cu succes"
                let message = "Categoria a fost adăugată!"
                let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { _ in
                    self.performSegue(withIdentifier: "backToCategoriesSegue", sender: nil)
                }))
                
                self.present(alert, animated: true)
                
            }
            else
            {
                alert(UIVC: self, title: "Eroare detectată", message: "O eroare a intervenit în procesul solicitat. Dacă problema persistă, contactați dezvoltatorii.")
            }
        }
    }
    
    let reference = Database.database().reference()
    
    override func viewDidLoad() {
        
    }
    
    
    
}
