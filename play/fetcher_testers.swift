//
//  fetcher_testers.swift
//  play
//
//  Created by Alexandru-Mihai Manolescu on 27/07/2019.
//  Copyright © 2019 Alexandru-Mihai Manolescu. All rights reserved.
//

import Foundation

func test_items()
{
    var fitems = [Item]()
    
    fetchItemsByCategory(category: "C1",completion: { (items) -> Void in
        
        fitems=items
        
        for obj in fitems
        {
            print(obj.description)
            
        }
        //            print("nr", fitems.count)
        //            print("finished running fetchAllItems")
    })
}

func test_bookings()
{
    //        let ref = Database.database().reference(withPath: "items-planner")
    //
    //
    //        ref.child("Items").observeSingleEvent(of: .value, with: { (snapshot) in
    //            // Get user value
    //            let value = snapshot.value as? NSDictionary
    //
    //            print(value)
    //
    //            // ...
    //        }) { (error) in
    //            print(error.localizedDescription)
    //        }
    //        //elem.setValue("12-26 August")
    
    //        Database.database().reference(withPath: "Bookings").observe(DataEventType.childAdded, with:
    //            {(snap) in print()
    //                let a = snap.childSnapshot(forPath: "descriere").value as! String
    //                print(a)
    //                print("inqgiowpagn")
    //        })
    
    
    //Database.database().reference(withPath: "items-planner").child("bugubugu").setValue("heei")
    
    var fbookings = [Booking]()
    
    fetchBookings(completion: { (bookings) -> Void in
        
        fbookings=bookings
        
        for obj in fbookings
        {
            print(obj.description)
        }
        
    })
    
    
    
}
