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
    let ref = Database.database().reference().child("Categories")
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayingItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tbv.dequeueReusableCell(withIdentifier: "AdminItemCell") as! AdminItemCell
            cell.itemNameLabel?.text="Articol: \(displayingItems[indexPath.row].name)"
            cell.categoryLabel?.text="Categorie: \(displayingItems[indexPath.row].category_name)"
            cell.descriptionTextView?.text="Descriere: \(displayingItems[indexPath.row].description)"
        return cell;
    }
    
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            let itemToDelete=self.displayingItems[indexPath.row]
            
            let ref=Database.database().reference()
            let path_to_storage = Storage.storage().reference().child("images")
            
            print(itemToDelete.images, " fjiohfpahwgpaw")
            for image in itemToDelete.images
            {
                print(image)
                path_to_storage.child(image.uid).delete(completion: { (error) in
                    print(error, error.debugDescription)
                })
            }
            
            let path_of_item=ref.child("Categories").child(itemToDelete.category_id).child("items").child(itemToDelete.id)
            path_of_item.removeValue()
        }
        
        return [delete]
    }
    
    
    @IBOutlet weak var tbv: UITableView!
    
    override func viewDidLoad()
    {
        self.tbv.delegate=self
        self.tbv.dataSource=self
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadDataFromDB()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        ref.removeAllObservers()
    }
    
    func loadDataFromDB()
    {
        
        //displayingCategories.removeAll()
        
        
        
        ref.observe(.value) { (allCategories) in
            self.items.removeAll()
            self.displayingItems.removeAll()
            
            for category in allCategories.children.allObjects as! [DataSnapshot]{
                let category_name = category.childSnapshot(forPath: "name").value as! String
                displayingCategories.append(category_name)
                
                let packets = category.childSnapshot(forPath: "items")
                //print(packets)
                
                for item in packets.children.allObjects as! [DataSnapshot]
                {
                    let currentItem = Item()
                    currentItem.category_id = category.key as! String
                    currentItem.category_name = category_name
                    currentItem.description = item.childSnapshot(forPath: "descriere").value as! String
                    currentItem.name = item.childSnapshot(forPath: "name").value as! String
                    currentItem.id = item.key
                    
                    for image in item.childSnapshot(forPath: "images").children.allObjects as! [DataSnapshot]
                    {
                        //                        currentItem.image_url = imageurl.value as! String
                        //print(imageurl)
                        
                        if((image.childSnapshot(forPath: "uid").exists())&&(image.childSnapshot(forPath: "uid").exists()))
                        {
                            let fbimage = FBImage()
                            fbimage.uid = image.childSnapshot(forPath: "uid").value as! String
                            fbimage.url = image.childSnapshot(forPath: "url").value as! String
                            currentItem.images.append(fbimage)
                        }

                    }
                    
                    self.items.append(currentItem)
                    self.displayingItems.append(currentItem)
                    
                }
            }
            
            self.tbv.reloadData()
//            scrollToFirstRow(in: self.tbv)
//            self.pickerCategory.reloadAllComponents()
        }
        
    }
    

}
