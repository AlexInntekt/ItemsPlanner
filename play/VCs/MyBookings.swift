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
    
    
    var displayingBookings = [Booking]()
    
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
        return displayingBookings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = self.tbv.dequeueReusableCell(withIdentifier: "TBVBookingCell") as! TBVBookingCell
        
        let startDate = convertEnDateToRo(displayingBookings[indexPath.row].startDate)
        let endDate = convertEnDateToRo(displayingBookings[indexPath.row].endDate)
        
        var text = displayingBookings[indexPath.row].description
            text += "\n Perioadă: \(startDate) - \(endDate)"
        cell.itemName?.text = displayingBookings[indexPath.row].itemName
        cell.labelName.isUserInteractionEnabled = false
        
        cell.labelName?.text = text
        
        return cell;
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            
            let bk = self.displayingBookings[indexPath.row]
            self.displayingBookings.remove(at: indexPath.row)
            self.tbv.reloadData()
            deleteMyBookingWithId(bk_id: bk.id, item_id: bk.itemId, cat: bk.category)
            
        }
        
        let edit = UITableViewRowAction(style: .normal, title: "Edit") { (action, indexPath) in
            self.performSegue(withIdentifier: "goToEditVC", sender: nil)
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
        
        var bookings = [Booking]()
        
        var ref = Database.database().reference().child("Users").child(currentUserId!).child("bookings")
        
        
        print("running loadBookings()")
        

//            self.displayingBookings.removeAll()
//            bookings.removeAll()
        
            ref.observe(.childAdded) { (snap) in
                //print(snap.key)

                
                //self.displayingBookings.removeAll()
                
                var bookings = [Booking]()
                
                let ref2 = Database.database().reference(withPath: "Bookings").queryOrderedByKey().queryEqual(toValue: snap.key)
                
              
//                ref2.observeSingleEvent(of: .childAdded , with:
//                                    {(snap) in print()
//                       print(snap)
//                })
                
                ref2.observeSingleEvent(of: .childRemoved, with:
                    {(snap) in print()
                        var int=0;
                        for obj in self.displayingBookings
                        {
                            if(obj.id==snap.key)
                            {
                                self.displayingBookings.remove(at: int)
                                self.tbv.reloadData()
                            }
                            int+=1
                        }
                })
                
                ref2.observeSingleEvent(of: .childAdded , with:
                    {(snap) in print()

                        print("fbuiwgeiwbGIwge")

                        let currentBooking = Booking()
                        currentBooking.category = snap.childSnapshot(forPath: "categoryId").value as! String
                        currentBooking.description = snap.childSnapshot(forPath: "descriere").value as! String
                        currentBooking.user = snap.childSnapshot(forPath: "user").value as! String
                        currentBooking.itemId = snap.childSnapshot(forPath: "itemId").value as! String
                        currentBooking.itemName = snap.childSnapshot(forPath: "itemName").value as! String
                        currentBooking.startDate = snap.childSnapshot(forPath: "interval").childSnapshot(forPath: "from").value as! String
                        currentBooking.endDate = snap.childSnapshot(forPath: "interval").childSnapshot(forPath: "till").value as! String
                        currentBooking.id = snap.key

                        self.displayingBookings.append(currentBooking)
                        print(currentBooking.description)
                        self.tbv.reloadData()

                })
            }
        
        

    }
}
