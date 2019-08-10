//
//  AdminItemsVC.swift
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

class AdminItemsVC: UIViewController,UITableViewDelegate, UITableViewDataSource
{
    var displayingItems=[Item]()
    var items=[Item]()
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayingItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tbv.dequeueReusableCell(withIdentifier: "AdminItemCell") as! AdminItemCell
            cell.itemNameLabel?.text="Articol: \(displayingItems[indexPath.row].name)"
            cell.categoryLabel?.text="Categorie: \(displayingItems[indexPath.row].category)"
            cell.descriptionTextView?.text="Descriere: \(displayingItems[indexPath.row].description)"
        return cell;
    }
    
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            let itemToDelete=self.displayingItems[indexPath.row]
            
            let ref=Database.database().reference()
            
            let path_of_item=ref.child("Categories").child(itemToDelete.category).child("items").child(itemToDelete.id)
                path_of_item.removeValue()
            print("tapped delete")
//            let bk = self.displayingItems[indexPath.row]
            self.displayingItems.remove(at: indexPath.row)
            self.tbv.reloadData()
//            deleteMyBookingWithId(bk_id: bk.id, item_id: bk.itemId, cat: bk.category)
        }
        
        return [delete]
    }
    
    
    @IBOutlet weak var tbv: UITableView!
    
    override func viewDidLoad()
    {
        self.tbv.delegate=self
        self.tbv.dataSource=self
        
        loadDataFromDB()
    }
    
    func loadDataFromDB()
    {
        items.removeAll()
        displayingItems.removeAll()
        //displayingCategories.removeAll()
        
        let ref = Database.database().reference().child("Categories")
        
        ref.observe(.value) { (allCategories) in
            
            for category in allCategories.children.allObjects as! [DataSnapshot]{
                displayingCategories.append(category.key)
                
                let packets = category.childSnapshot(forPath: "items")
                //print(packets)
                
                for item in packets.children.allObjects as! [DataSnapshot]
                {
                    let currentItem = Item()
                    currentItem.category = category.key as! String
                    currentItem.description = item.childSnapshot(forPath: "descriere").value as! String
                    currentItem.name = item.childSnapshot(forPath: "name").value as! String
                    currentItem.id = item.key
                    
                    print(currentItem.category)
                    
                    self.items.append(currentItem)
                    self.displayingItems.append(currentItem)
                    
                }
            }
            
            self.tbv.reloadData()
//            self.pickerCategory.reloadAllComponents()
        }
        
    }
}
