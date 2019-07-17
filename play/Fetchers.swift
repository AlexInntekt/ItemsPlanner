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

func fetchBookings(completion: @escaping (_ success: [Booking]) -> Void)->[Booking]
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
    
    print("Starting observing");
    ref.observe(.value, with: { (snap: DataSnapshot!) in

        countItems+=1
        
        let currentBooking = Booking()
            currentBooking.description = snap.childSnapshot(forPath: "descriere").value as! String
            currentBooking.interval = snap.childSnapshot(forPath: "interval").value as! String
            currentBooking.user = snap.childSnapshot(forPath: "user").value as! String
        
        bookings.append(currentBooking)
        if(snap.childrenCount==countItems)
        {
            completion(bookings)
        }
    })
    
        
    print("Number of bookings fetched: ", bookings.count)
    
    return bookings
}
