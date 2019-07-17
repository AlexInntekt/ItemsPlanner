//
//  Fetchers.swift
//  play
//
//  Created by Alexandru-Mihai Manolescu on 17/07/2019.
//  Copyright © 2019 Alexandru-Mihai Manolescu. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

func fetchBookings(completion: @escaping (_ success: [Booking]) -> Void)
{
    var bookings = [Booking]()
    
    var countItems=0
    
//    Database.database().reference(withPath: "Bookings").observe(DataEventType.childAdded, with:
//        {(snap) in print()
//            let currentBooking = Booking()
//                currentBooking.description = snap.childSnapshot(forPath: "descriere").value as! String
//                currentBooking.interval = snap.childSnapshot(forPath: "interval").value as! String
//                currentBooking.user = snap.childSnapshot(forPath: "user").value as! String
//
//            bookings.append(currentBooking)
//
//            countItems+=1
//            if(countItems==)
//    })
    
    let ref = Database.database().reference(withPath: "Bookings")
    
    ref.observe(DataEventType.childAdded , with:
        {(snap) in print()
            let no_items=Int(snap.childrenCount)
    
            ref.observe(DataEventType.childAdded, with:
                {(snap) in print()
                    countItems+=1
                    
                    let currentBooking = Booking()
                    currentBooking.description = snap.childSnapshot(forPath: "descriere").value as! String
                    currentBooking.interval = snap.childSnapshot(forPath: "interval").value as! String
                    currentBooking.user = snap.childSnapshot(forPath: "user").value as! String
                    
                    bookings.append(currentBooking)
                    if(no_items==countItems)
                    {
                        completion(bookings)
                    }
            })
    })
    
}


func fetchItemsByCategory(category: String,completion: @escaping (_ success: [Item]) -> Void)
{
    var items = [Item]()
    
    let ref = Database.database().reference(withPath: "Categories").child("C1")
    
    var countItems=0
    
    ref.observe(DataEventType.childAdded , with:
        {(snap) in print()
        let no_items=Int(snap.childrenCount)
            
            ref.child("items").observe(DataEventType.childAdded, with:
                {(snap) in print()
                    
                    countItems+=1
                    
                    
                    let currentItem = Item()
                    currentItem.description = snap.childSnapshot(forPath: "descriere").value as! String
                    currentItem.image_url = snap.childSnapshot(forPath: "image_url").value as! String
                    currentItem.name = snap.childSnapshot(forPath: "name").value as! String
                    
                    
                    items.append(currentItem)
                    if(countItems==no_items)
                    {
                        completion(items)
                    }
            })
    })
    
    


    
}
