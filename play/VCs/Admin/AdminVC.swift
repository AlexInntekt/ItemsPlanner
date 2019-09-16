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

class AdminVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate
{

    var bookingsReference = Database.database().reference().child("Users")
    
    var displayingBookings = [BookingPack]()
    var allBookings = [BookingPack]()
    
    var searchBar: UISearchBar!
    
    @IBOutlet var TBVAdmin: UITableView!
    
    override func viewDidLoad()
    {
        configureSearchController()
        TBVAdmin.delegate = self
        TBVAdmin.dataSource = self
        
        loadDataFromDB()
                
        //searchBar.showsCancelButton = true
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayingBookings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = self.TBVAdmin.dequeueReusableCell(withIdentifier: "AdminBookingCell") as! AdminBookingCell
     
            let booking = displayingBookings[indexPath.row]
        
            cell.itemNameLabel?.text = "Articol: \(booking.itemName)"
            cell.userLabel?.text = booking.username
            let startDate = convertEnDateToRo(booking.startDate)
            let endDate = convertEnDateToRo(booking.endDate)
            let date="\(startDate) - \(endDate)"
            cell.phoneLabel?.text = booking.phone
            cell.dateLabel?.text = date
            cell.itsDescription.text = "Descriere: \(booking.description) \nCantitate: \(booking.quantity)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            
            let title = "Acțiune periculoasă"
            let message = "Sunteți sigur de această acțiune?"
            let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Nu, anulează", style: UIAlertAction.Style.cancel, handler: { _ in
            }))
            alert.addAction(UIAlertAction(title: "Da, șterge", style: UIAlertAction.Style.destructive, handler: { _ in
                
                let bk = self.displayingBookings[indexPath.row]
                self.displayingBookings.remove(at: indexPath.row)
                self.TBVAdmin.reloadData()
                deleteMyBookingWithId(bk_id: bk.id, item_id: bk.itemId, cat: bk.category_id)
            }))
            
            self.present(alert, animated: true)
        }
        
        return [delete]
    }
    
    func configureSearchController() {
        // Initialize and perform a minimum configuration to the search controller.
        searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: 200, height: 20))
        
        //        searchController.dimsBackgroundDuringPresentation = false
        searchBar.placeholder = "Căutare generală"
        searchBar.delegate = self
        searchBar.sizeToFit()
        
        // Place the search bar view to the tableview headerview.
        TBVAdmin.tableHeaderView = searchBar
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar)
    {
        print("searchBarTextDidBeginEditing rgGwrgwRGHwhharga")
        shouldShowSearchResults = true
        TBVAdmin.reloadData()
    }
    
    
    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        let searchString = searchBar.text

        
        displayingBookings = allBookings.filter({( booking : BookingPack) -> Bool in
            let block = booking.itemName.lowercased().contains(searchString!.lowercased()) ||
                        booking.description.lowercased().contains(searchString!.lowercased()) ||
                        booking.username.lowercased().contains(searchString!.lowercased()) ||
            
                        booking.category_name.lowercased().contains(searchString!.lowercased())
            
            
            return block
        })
        
        if(searchText=="")
        {
            displayingBookings=allBookings
            shouldShowSearchResults=false
        }

        if searchBar.text == nil || searchBar.text == ""
        {
            searchBar.perform(#selector(self.resignFirstResponder), with: nil, afterDelay: 0.1)
        }
        
        TBVAdmin.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        print("searchBarSearchButtonClicked")
        searchBar.resignFirstResponder()
    }
    
    
    func loadDataFromDB()
    {
        let currentUserId = Auth.auth().currentUser?.uid

       
        
        let ref1 = Database.database().reference().child("Users")
        ref1.observeSingleEvent(of: .value) { (snap) in
            
            for child in snap.children.allObjects as! [DataSnapshot]{
                
                let phone = child.childSnapshot(forPath: "phoneNumber").value as! String
                let nameOfOwner = child.childSnapshot(forPath: "name").value as! String
                let userUid = child.key
                
                self.bookingsReference = Database.database().reference().child("Users").child(userUid).child("bookings")
                
                self.bookingsReference.observe(.childAdded) { (snap) in
                    
                    let ref2 = Database.database().reference(withPath: "Bookings").queryOrderedByKey().queryEqual(toValue: snap.key)
                    
                    
                    ref2.observeSingleEvent(of: .childRemoved, with:
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
                            int=0;
                            for obj in self.allBookings
                            {
                                if(obj.id==snap.key)
                                {
                                    self.allBookings.remove(at: int)
                                }
                                int+=1
                            }
                            
                            self.TBVAdmin.reloadData()
                    })
                    
                    ref2.observeSingleEvent(of: .childAdded , with:
                        {(snap) in print()
                            
                            
                            let currentBooking = BookingPack()
                            currentBooking.category_id = snap.childSnapshot(forPath: "categoryId").value as! String
                            currentBooking.category_name = snap.childSnapshot(forPath: "categoryName").value as! String
                            currentBooking.description = snap.childSnapshot(forPath: "descriere").value as! String
                            currentBooking.user = snap.childSnapshot(forPath: "user").value as! String
                            currentBooking.itemId = snap.childSnapshot(forPath: "itemId").value as! String
                            currentBooking.itemName = snap.childSnapshot(forPath: "itemName").value as! String
                            currentBooking.startDate = snap.childSnapshot(forPath: "interval").childSnapshot(forPath: "from").value as! String
                            currentBooking.endDate = snap.childSnapshot(forPath: "interval").childSnapshot(forPath: "till").value as! String
                            currentBooking.quantity = snap.childSnapshot(forPath: "cantitate").value as! Int
                            currentBooking.id = snap.key
                            currentBooking.phone=phone
                            currentBooking.username=nameOfOwner
                            self.allBookings.append(currentBooking)
                            self.displayingBookings.append(currentBooking)
                            self.TBVAdmin.reloadData()
                            
                    })
                }
            }
            
            
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        bookingsReference.removeAllObservers()
    }
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
}
