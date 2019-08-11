//
//  AdminCategoriesVC.swift
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

class AdminCategoriesVC: UIViewController, UITableViewDelegate, UITableViewDataSource
{

    @IBOutlet weak var tbv: UITableView!
    
    var displayingCategories=[String]()
    
    let reference = Database.database().reference()
    
    override func viewDidLoad()
    {
        self.tbv.delegate=self
        self.tbv.dataSource=self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadCategories()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayingCategories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
            cell.textLabel?.text = displayingCategories[indexPath.row]
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            
//            let key = self.displayingCategories[indexPath.row]
//            self.reference.child("Categories").child(key).removeValue()
//            self.tbv.reloadData()
            let title = "Acțiune periculoasă"
            let message = "Ștergerea unei categorii duce la ștergerea completă și a articolelor aflate sub această categorie. Sunteți sigur de această acțiune?"
            let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Nu, anulează", style: UIAlertAction.Style.cancel, handler: { _ in
            }))
            alert.addAction(UIAlertAction(title: "Da, șterge", style: UIAlertAction.Style.destructive, handler: { _ in
                
                let key = self.displayingCategories[indexPath.row]
                self.reference.child("Categories").child(key).removeValue()
                self.tbv.reloadData()
            }))

            self.present(alert, animated: true)
        }
        
        return [delete]
    }
    
    func loadCategories()
    {
        let path = reference.child("Categories")
        
        path.observe(DataEventType.value) { (pack) in
            self.displayingCategories.removeAll()
            for category in pack.children.allObjects as! [DataSnapshot]{
            
                let name = category.key as! String
                self.displayingCategories.append(name)
                
                self.tbv.reloadData()
            }
        }
    }
    
    
}
