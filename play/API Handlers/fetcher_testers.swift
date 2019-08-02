//
//  fetcher_testers.swift
//  play
//
//  Created by Alexandru-Mihai Manolescu on 27/07/2019.
//  Copyright © 2019 Alexandru-Mihai Manolescu. All rights reserved.
//

import Foundation

func test_fetch_categories()
{
    var fetched_categories=[String]()
    
    fetchAllCategories(completion: { (categories) -> Void in
        
        fetched_categories=categories
        
        for categ in fetched_categories
        {
            print(categ)
        }
        
    })
}

func test_fetch_all_items()
{
    var items = [Item]()
    
    fetchAllItems(completion: { (fetched_items) -> Void in
        
        items=fetched_items
        
        for item in items
        {
            print(item.description)
        }
        
    })
}

func fetch_items()
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
    
    fetchBookings(by: "B1",completion: { (bookings) -> Void in
        
        fbookings=bookings
        
        for obj in fbookings
        {
            print(obj.description)
            print(obj.endDate)
            print(obj.user)
        }
        
    })
    
}


func test_fetchAllBookingsByItemID()
{
    fetchAllBookingsByItemID(item: "I2", category: "C1", completion: { (bookings) -> Void in
        
        
        for obj in bookings
        {
            print(obj.description)
        }
        
    })
}
