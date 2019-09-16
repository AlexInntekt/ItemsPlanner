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

class AdminItemsVC: UIViewController,UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate
{
    var displayingItems=[Item]()
    var items=[Item]()
    let ref = Database.database().reference().child("Categories")
    var searchBar: UISearchBar!
    
    @IBOutlet weak var container: UIView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayingItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tbv.dequeueReusableCell(withIdentifier: "AdminItemCell") as! AdminItemCell
            let thisItem = displayingItems[indexPath.row]
            cell.itemNameLabel?.text="Articol: \(thisItem.name)"
            cell.categoryLabel?.text="Categorie: \(thisItem.category_name)"
            cell.descriptionTextView?.text="Cantitate: \(thisItem.quantity) \nDescriere: \(thisItem.description)"
        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        performSegue(withIdentifier: "modifyItemSegue", sender: displayingItems[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in

            let title = "Acțiune periculoasă"
            let message = "Ștergerea unui articol duce la ștergerea recursivă a tuturor rezervărilor ce țin de acesta. Sunteți sigur de această acțiune?"
            let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Nu, anulează", style: UIAlertAction.Style.cancel, handler: { _ in
            }))
            alert.addAction(UIAlertAction(title: "Da, șterge", style: UIAlertAction.Style.destructive, handler: { _ in

                deleteItem(self.displayingItems[indexPath.row])
            }))
            
            self.present(alert, animated: true)
        }
        
        let edit = UITableViewRowAction(style: .normal, title: "Editează") { (action, indexPath) in
            
            self.performSegue(withIdentifier: "modifyItemSegue", sender: self.displayingItems[indexPath.row])
            
        }
        
        return [delete, edit]
    }
    
    
    @IBOutlet weak var tbv: UITableView!
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar)
    {
        print("searchBarTextDidBeginEditing rgGwrgwRGHwhharga")
        shouldShowSearchResults = true
        displayingItems.sort(by: { $0.name < $1.name })
        tbv.reloadData()
    }
    
    func configureSearchController() {
        // Initialize and perform a minimum configuration to the search controller.
        searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: 200, height: 20))
        
        //        searchController.dimsBackgroundDuringPresentation = false
        searchBar.placeholder = "Căutare generală"
        searchBar.delegate = self
        searchBar.sizeToFit()
        
        // Place the search bar view to the tableview headerview.
        tbv.tableHeaderView = searchBar
        //container = searchBar
    }
    
    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        let searchString = searchBar.text
        
        
        displayingItems = items.filter({( item : Item) -> Bool in
            let block = item.name.lowercased().contains(searchString!.lowercased()) ||
                item.description.lowercased().contains(searchString!.lowercased()) ||
                item.category_name.lowercased().contains(searchString!.lowercased())
            
            return block
        })
        
        if(searchText=="")
        {
            displayingItems=items
            shouldShowSearchResults=false
        }
        
        displayingItems.sort(by: { $0.name < $1.name })
        tbv.reloadData()
    }
    
    override func viewDidLoad()
    {
        self.tbv.delegate=self
        self.tbv.dataSource=self
        configureSearchController()
        

        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        
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
                    if(item.childSnapshot(forPath: "descriere").exists())
                    {
                        currentItem.description = item.childSnapshot(forPath: "descriere").value as! String
                    }
                    if(item.childSnapshot(forPath: "name").exists())
                    {
                        currentItem.name = item.childSnapshot(forPath: "name").value as! String
                    }
                    if(item.childSnapshot(forPath: "cantitate").exists())
                    {
                        currentItem.quantity = item.childSnapshot(forPath: "cantitate").value as! Int
                    }
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
                            fbimage.accesid = image.key as! String
                            currentItem.images.append(fbimage)
                        }
                        
                    }
                    
                    
                    self.items.append(currentItem)
                    self.displayingItems.append(currentItem)
                    
                    
                }
            }
            
            self.displayingItems.sort(by: { $0.name < $1.name })
            self.tbv.reloadData()
//            scrollToFirstRow(in: self.tbv)
//            self.pickerCategory.reloadAllComponents()
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if(segue.identifier=="modifyItemSegue")
        {
            let obj = sender as! Item
            let defVC = segue.destination as! ModifyItemAdminVC
            defVC.currentItem = obj
            defVC.initialItem = obj.copy()
        }
    }
    
    //Calls this function when the tap is recognized.
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

}
