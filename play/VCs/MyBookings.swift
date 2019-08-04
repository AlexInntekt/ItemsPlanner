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

class MyBookingsVC: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    
    
    var bookings = [Booking]()
    
    @IBOutlet var tbv: UITableView!
    
    override func viewDidLoad()
    {
        tbv.delegate = self
        tbv.dataSource = self
        
        loadBookings()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = self.tbv.dequeueReusableCell(withIdentifier: "TBVBookingCell") as! TBVBookingCell
        
        let startDate = convertEnDateToRo(bookings[indexPath.row].startDate)
        let endDate = convertEnDateToRo(bookings[indexPath.row].endDate)
        
        var text = bookings[indexPath.row].description
            text += "\n Perioadă: \(startDate) - \(endDate)"
        cell.itemName?.text = bookings[indexPath.row].itemName
        cell.labelName.isUserInteractionEnabled = false
        
        cell.labelName?.text = text
        
        return cell;
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            
            let bk = self.bookings[indexPath.row]
            self.bookings.remove(at: indexPath.row)
            self.tbv.reloadData()
            deleteMyBookingWithId(bk_id: bk.id, item_id: bk.itemId, cat: bk.category)
            
        }
        
        let edit = UITableViewRowAction(style: .normal, title: "Edit") { (action, indexPath) in
            // share item at indexPath
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
        
        
        let ref = Database.database().reference().child("Users").child(currentUserId!).child("bookings")
        
        var bookingsIDs = [String]()
        
        print("running loadBookings()")
        
        ref.observe(.value, with: { (snapshot: DataSnapshot!) in
            //print(snapshot.childrenCount)
            
            
            ref.observe(DataEventType.childAdded) { (snap) in
                //print(snap.key)
                bookingsIDs.append(snap.key)
                
                print(snap.key)
                
                
            }
        })
        
        
        
        
//        fetchAllBookingsByUser(user_id: currentUserId ?? "null") { fetched_bookings in
//
//            self.bookings = fetched_bookings
//
//            print(self.bookings[0].description)
//
//            self.tbv.reloadData()
//        }
    }
}
