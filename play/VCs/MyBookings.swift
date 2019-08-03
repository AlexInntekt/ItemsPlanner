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
        
//        let share = UITableViewRowAction(style: .normal, title: "Disable") { (action, indexPath) in
//            // share item at indexPath
//        }
//
//        share.backgroundColor = UIColor.blue
//
        return [delete]
    }
    
    func setup()
    {
        
    }
    
    func loadBookings()
    {
        let currentUserId = Auth.auth().currentUser?.uid
        fetchAllBookingsByUser(user_id: currentUserId ?? "null") { fetched_bookings in
            
            self.bookings = fetched_bookings
            
            print(self.bookings[0].description)
            
            self.tbv.reloadData()
        }
    }
}
