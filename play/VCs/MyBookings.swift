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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //self.performSegue(withIdentifier: "goToEditVC", sender: self.displayingBookings[indexPath.row])
        
        let currentBooking = displayingBookings[indexPath.row]
        
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
                        
                        self.packItem = localItem
                        self.performSegue(withIdentifier: "goToEditVC", sender: currentBooking)
                        
                    }
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            
            let bk = self.displayingBookings[indexPath.row]
            self.displayingBookings.remove(at: indexPath.row)
            self.tbv.reloadData()
            deleteMyBookingWithId(bk_id: bk.id, item_id: bk.itemId, cat: bk.category)
            
        }
        
        let info = UITableViewRowAction(style: .normal, title: "Info") { (action, indexPath) in
            self.performSegue(withIdentifier: "goToEditVC", sender: self.displayingBookings[indexPath.row])
        }

        info.backgroundColor = UIColor(red:0.27, green:0.43, blue:0.62, alpha:1.0)

        return [delete,info]
    }
    
    func setup()
    {
        
    }
    
    func loadBookings()
    {
        let currentUserId = Auth.auth().currentUser?.uid
        
        var bookings = [Booking]()
        

            bookingsReference = Database.database().reference().child("Users").child(currentUserId!).child("bookings")
            bookingsReference.observe(.childAdded) { (snap) in

                
                var bookings = [Booking]()
                
                self.ref2 = Database.database().reference(withPath: "Bookings").queryOrderedByKey().queryEqual(toValue: snap.key)
                
                
                self.ref2.observe(.childRemoved, with:
                    {(snap) in print()
                        var int=0;
                        for obj in self.displayingBookings
                        {
                            if(obj.id==snap.key)
                            {
                                self.displayingBookings.remove(at: int)
                            }
                            int+=1
                        }
                        int=0
                        for obj in self.allBookings
                        {
                            if(obj.id==snap.key)
                            {
                                self.allBookings.remove(at: int)
                            }
                            int+=1
                        }
                        
                         self.tbv.reloadData()
                })
                
                self.ref2.observeSingleEvent(of: .childAdded , with:
                    {(snap) in print()

                        let currentBooking = Booking()
                        currentBooking.category = snap.childSnapshot(forPath: "categoryId").value as! String
                        currentBooking.description = snap.childSnapshot(forPath: "descriere").value as! String
                        currentBooking.user = snap.childSnapshot(forPath: "user").value as! String
                        currentBooking.itemId = snap.childSnapshot(forPath: "itemId").value as! String
                        currentBooking.itemName = snap.childSnapshot(forPath: "itemName").value as! String
                        currentBooking.startDate = snap.childSnapshot(forPath: "interval").childSnapshot(forPath: "from").value as! String
                        currentBooking.endDate = snap.childSnapshot(forPath: "interval").childSnapshot(forPath: "till").value as! String
                        currentBooking.id = snap.key
                        currentBooking.quantity = snap.childSnapshot(forPath: "cantitate").value as! Int

                        self.displayingBookings.append(currentBooking)
                        self.allBookings.append(currentBooking)
                        self.tbv.reloadData()

                })
            }
        
        

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
