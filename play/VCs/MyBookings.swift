//
//  MyBookings.swift
//  play
//
//  Created by Alexandru-Mihai Manolescu on 01/08/2019.
//  Copyright © 2019 Alexandru-Mihai Manolescu. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class MyBookingsVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate
{
    var bookingsReference = Database.database().reference().child("Users")
    var ref2 = Database.database().reference(withPath: "Bookings").queryOrderedByKey()
    
    var displayingBookings = [Booking]()
    var allBookings = [Booking]()
    
    var packItem = Item() //fetched item of a selected booking is saved here before triggering segue
    
    var searchBar: UISearchBar!
    
    @IBOutlet var tbv: UITableView!
    
    override func viewDidLoad()
    {
        tbv.delegate = self
        tbv.dataSource = self
        
        configureSearchController()
        
        loadBookings()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar)
    {
        shouldShowSearchResults = true
        tbv.reloadData()
    }
    
    func configureSearchController() {
        // Initialize and perform a minimum configuration to the search controller.
        searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: 200, height: 20))
        
        //        searchController.dimsBackgroundDuringPresentation = false
        searchBar.placeholder = "Cautare generală"
        searchBar.delegate = self
        searchBar.sizeToFit()
        
        // Place the search bar view to the tableview headerview.
        tbv.tableHeaderView = searchBar
    }
    
    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        let searchString = searchBar.text
        
        
        displayingBookings = allBookings.filter({( booking : Booking) -> Bool in
            let block = booking.description.lowercased().contains(searchString!.lowercased()) ||
                        booking.itemName.lowercased().contains(searchString!.lowercased()) ||
                        booking.category.lowercased().contains(searchString!.lowercased())
            
            return block
        })
        
        if(searchText=="")
        {
            displayingBookings=allBookings
            shouldShowSearchResults=false
        }
        
        tbv.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayingBookings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = self.tbv.dequeueReusableCell(withIdentifier: "TBVBookingCell") as! TBVBookingCell
        
        let startDate = convertEnDateToRo(displayingBookings[indexPath.row].startDate)
        let endDate = convertEnDateToRo(displayingBookings[indexPath.row].endDate)
        let quantity = displayingBookings[indexPath.row].quantity
        var text = displayingBookings[indexPath.row].description
            text += "\n Perioadă: \(startDate) - \(endDate)"
            text += "\n Cantitate: \(quantity)"
        cell.itemName?.text = displayingBookings[indexPath.row].itemName
        cell.labelName.isUserInteractionEnabled = false
        
        cell.labelName?.text = text
        
        return cell;
    }
    
    func handleEditTap(_ currentBooking: Booking)
    {
        reference.child("Categories").observeSingleEvent(of: .value) { (pack) in
            for categ in pack.children.allObjects as! [DataSnapshot]
            {
                let category_id = categ.key as! String
                
                let items = categ.childSnapshot(forPath: "items").children.allObjects as! [DataSnapshot]
                
                for fitem in items
                {
                    if currentBooking.itemId == fitem.key as! String
                    {
                        
                        let localItem = Item()
                        localItem.name = fitem.childSnapshot(forPath: "name").value as! String
                        localItem.category_id = category_id
                        localItem.category_name = categ.childSnapshot(forPath: "name").value as! String
                        localItem.id = fitem.key as! String
                        localItem.quantity = fitem.childSnapshot(forPath: "cantitate").value as! Int
                        localItem.description = fitem.childSnapshot(forPath: "descriere").value as! String
                        
                        for image in fitem.childSnapshot(forPath: "images").children.allObjects as! [DataSnapshot]
                        {
                            let fbimage = FBImage()
                                fbimage.url = image.childSnapshot(forPath: "url").value as! String
                                fbimage.uid = image.childSnapshot(forPath: "uid").value as! String
                            
                            localItem.images.append(fbimage)
                        }
                        
                        self.packItem = localItem
                        self.performSegue(withIdentifier: "goToEditVC", sender: currentBooking)
                        
                    }
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //self.performSegue(withIdentifier: "goToEditVC", sender: self.displayingBookings[indexPath.row])
        
        let currentBooking = displayingBookings[indexPath.row]

        handleEditTap(currentBooking)
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "Șterge") { (action, indexPath) in
            
            let bk = self.displayingBookings[indexPath.row]
            self.displayingBookings.remove(at: indexPath.row)
            self.tbv.reloadData()
            deleteMyBookingWithId(bk_id: bk.id, item_id: bk.itemId, cat: bk.category)
            
        }
        
        let edit = UITableViewRowAction(style: .normal, title: "Editează") { (action, indexPath) in
            self.handleEditTap(self.displayingBookings[indexPath.row])
        }

        edit.backgroundColor = UIColor(red:0.27, green:0.43, blue:0.62, alpha:1.0)

        return [delete,edit]
    }
    
    func setup()
    {
        
    }
    
    func loadBookings()
    {
        let currentUserId = Auth.auth().currentUser?.uid

        bookingsReference = Database.database().reference().child("Bookings")
        
        bookingsReference.observe(.value) { (list) in
            self.displayingBookings.removeAll()
            self.allBookings.removeAll()
            
            //this is usefull if there is no booking
            self.tbv.reloadData()
            
            for obj in list.children.allObjects as! [DataSnapshot]
            {
                let itsUser = obj.childSnapshot(forPath: "user").value as! String
                if(itsUser==currentUserId)
                {
                    
                    if(self.isSnapComplete(obj))
                    {
                        let currentBooking = Booking()
                        currentBooking.category = obj.childSnapshot(forPath: "categoryId").value as! String
                        currentBooking.description = obj.childSnapshot(forPath: "descriere").value as! String
                        currentBooking.user = obj.childSnapshot(forPath: "user").value as! String
                        currentBooking.itemId = obj.childSnapshot(forPath: "itemId").value as! String
                        currentBooking.itemName = obj.childSnapshot(forPath: "itemName").value as! String
                        currentBooking.startDate = obj.childSnapshot(forPath: "interval").childSnapshot(forPath: "from").value as! String
                        currentBooking.endDate = obj.childSnapshot(forPath: "interval").childSnapshot(forPath: "till").value as! String
                        currentBooking.id = obj.key
                        currentBooking.quantity = obj.childSnapshot(forPath: "cantitate").value as! Int
                        
                        self.displayingBookings.append(currentBooking)
                        self.allBookings.append(currentBooking)
                        self.tbv.reloadData()
                    }
                }

            }
            
        }
        
    }
    
    func isSnapComplete(_ obj: DataSnapshot)->Bool
    {
        var cond = false
        
        if(obj.childSnapshot(forPath: "categoryId").exists() &&
            obj.childSnapshot(forPath: "descriere").exists() &&
            obj.childSnapshot(forPath: "user").exists() &&
            obj.childSnapshot(forPath: "itemId").exists() &&
            obj.childSnapshot(forPath: "itemName").exists() &&
            obj.childSnapshot(forPath: "interval").childSnapshot(forPath: "from").exists() &&
            obj.childSnapshot(forPath: "interval").childSnapshot(forPath: "till").exists() &&
            obj.childSnapshot(forPath: "cantitate").exists())
        {
            cond = true
        }
        
        return cond
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier=="goToEditVC")
        {
            let currentBooking = sender as! Booking
            
            let defVC = segue.destination as! BookItemVC

            defVC.editMode = true
            defVC.existingBookingToModify = currentBooking
            defVC.currentItem = packItem
            
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        bookingsReference.removeAllObservers()
        ref2.removeAllObservers()
    }
}
