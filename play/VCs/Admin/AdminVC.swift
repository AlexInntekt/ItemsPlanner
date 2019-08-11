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

class AdminVC: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    var bookingsReference = Database.database().reference().child("Users")
    
    var displayingBookings = [BookingPack]()
    
    @IBOutlet var TBVAdmin: UITableView!
    
    override func viewDidLoad()
    {
        TBVAdmin.delegate = self
        TBVAdmin.dataSource = self
        
        loadDataFromDB()
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
     
            cell.itemNameLabel?.text=displayingBookings[indexPath.row].itemName
            cell.userLabel?.text=displayingBookings[indexPath.row].username
            let startDate=displayingBookings[indexPath.row].startDate
            let endDate=displayingBookings[indexPath.row].endDate
            let date="\(startDate) - \(endDate)"
            cell.phoneLabel?.text=displayingBookings[indexPath.row].phone
            cell.dateLabel?.text=date
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            
            let bk = self.displayingBookings[indexPath.row]
            self.displayingBookings.remove(at: indexPath.row)
            self.TBVAdmin.reloadData()
            deleteMyBookingWithId(bk_id: bk.id, item_id: bk.itemId, cat: bk.category)
            
        }
        
        return [delete]
    }
    
    func setup()
    {
        
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
                                    self.TBVAdmin.reloadData()
                                }
                                int+=1
                            }
                    })
                    
                    ref2.observeSingleEvent(of: .childAdded , with:
                        {(snap) in print()
                            
                            print("fbuiwgeiwbGIwge")
                            
                            let currentBooking = BookingPack()
                            currentBooking.category = snap.childSnapshot(forPath: "categoryId").value as! String
                            currentBooking.description = snap.childSnapshot(forPath: "descriere").value as! String
                            currentBooking.user = snap.childSnapshot(forPath: "user").value as! String
                            currentBooking.itemId = snap.childSnapshot(forPath: "itemId").value as! String
                            currentBooking.itemName = snap.childSnapshot(forPath: "itemName").value as! String
                            currentBooking.startDate = snap.childSnapshot(forPath: "interval").childSnapshot(forPath: "from").value as! String
                            currentBooking.endDate = snap.childSnapshot(forPath: "interval").childSnapshot(forPath: "till").value as! String
                            currentBooking.id = snap.key
                            currentBooking.phone=phone
                            currentBooking.username=nameOfOwner
                            self.displayingBookings.append(currentBooking)
                            print(currentBooking.description)
                            self.TBVAdmin.reloadData()
                            
                    })
                }
            }
            
            
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        bookingsReference.removeAllObservers()
    }
    
}
