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

func fetchAllCategories(completion: @escaping (_ success: [String]) -> Void)
{
    var categories_names = [String]()

    Database.database().reference().child("Categories").observe(DataEventType.value, with: { (snap) in print()
        let count=Int(snap.childrenCount)
        
        let ref = Database.database().reference(withPath: "Categories")
        
        let db = ref.queryOrderedByKey()
        
        var ind=1;
        
        db.observe(DataEventType.childAdded, with:
            {(snap) in print()
                
                let name=snap.key as! String
                categories_names.append(name)
                
                if(count==ind)
                {
                    completion(categories_names)
                }
                ind+=1
        })
    })
}


func fetchBookings(by id: String, completion: @escaping (_ success: [Booking]) -> Void)
{
    var bookings = [Booking]()

    let ref = Database.database().reference(withPath: "Bookings").queryOrderedByKey().queryEqual(toValue: id)
    
    ref.observe(DataEventType.childAdded , with:
        {(snap) in print()

            
            let currentBooking = Booking()
            currentBooking.description = snap.childSnapshot(forPath: "descriere").value as! String
            currentBooking.startDate = snap.childSnapshot(forPath: "interval").childSnapshot(forPath: "from").value as! String
            currentBooking.endDate = snap.childSnapshot(forPath: "interval").childSnapshot(forPath: "till").value as! String
            currentBooking.user = snap.childSnapshot(forPath: "user").value as! String
            currentBooking.id = snap.key

            bookings.append(currentBooking)
            
            completion(bookings)
    })
}

func fetchAllBookings(completion: @escaping (_ success: [Booking]) -> Void)
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
                    currentBooking.startDate = snap.childSnapshot(forPath: "interval").childSnapshot(forPath: "from").value as! String
                    currentBooking.endDate = snap.childSnapshot(forPath: "interval").childSnapshot(forPath: "till").value as! String
                    currentBooking.user = snap.childSnapshot(forPath: "user").value as! String
                    currentBooking.id = snap.key
                    
                    bookings.append(currentBooking)
                    if(no_items==countItems)
                    {
                        completion(bookings)
                    }
            })
    })
    
}

func fetchAllItems(completion: @escaping (_ success: [Item]) -> Void)
{
    var categories = [String]()
    var items = [Item]()
    
    var ind=0 //counting number of fetched categories (item blocks)
    
    let ref = Database.database().reference(withPath: "Categories")
    
    Database.database().reference().child("Categories").observe(DataEventType.value, with: { (snap) in print()
        var count=Int(snap.childrenCount)

       
        
        fetchAllCategories(completion: { (fetched_categories) -> Void in
            
            categories=fetched_categories
            
            for cat in categories
            {
                print(cat)
                
                fetchItemsByCategory(category: cat,completion: { (fitems) -> Void in
                    
   
                    for obj in fitems
                    {
                        items.append(obj)
                    }
                    
                    if(ind==count) //if all items from all categories have been fetched, return completion with the array containing them
                    {
                        completion(items)
                    }
                    
                    
                    
                    print(ind, count)
                
                })
                ind+=1
                
            }

        })
        
    })
    
}


func fetchItemsByCategory(category: String,completion: @escaping (_ success: [Item]) -> Void)
{
    var items = [Item]()
    
    let ref = Database.database().reference(withPath: "Categories").child(category)
    
    var countItems=0
    
    ref.observe(DataEventType.childAdded , with:
        {(snap) in
        let no_items=Int(snap.childrenCount)
            
            ref.child("items").observe(DataEventType.childAdded, with:
                {(snap) in
                    
                    countItems+=1
                    
                    
                    let currentItem = Item()
                    currentItem.description = snap.childSnapshot(forPath: "descriere").value as! String
                    currentItem.image_url = snap.childSnapshot(forPath: "image_url").value as! String
                    currentItem.name = snap.childSnapshot(forPath: "name").value as! String
                    currentItem.category = category
                    currentItem.id = snap.key
                    
                    
                    
                    items.append(currentItem)
                    if(countItems==no_items)
                    {
                        completion(items)
                    }
            })
    })
    
}



func fetchAllBookingsIDsByItemID(item id: String, category cat: String, completion: @escaping (_ success: [String]) -> Void)
{
    var bookings = [String]()
    
    var item = Item()

    let ref = Database.database().reference(withPath: "Categories").child(cat).child("items").child(id).child("bookings")
    
    var count = 0

    ref.observe(.value, with: { (snapshot: DataSnapshot!) in
        //print(snapshot.childrenCount)
    
        
        ref.observe(DataEventType.childAdded) { (snap) in
            //print(snap.key)
            bookings.append(snap.key)
            count+=1
            if(count==snapshot.childrenCount)
            {
                completion(bookings)
            }
            
            
        }
    })
    
    
    
}

func fetchAllBookingsByItemID(item id: String, category cat: String, completion: @escaping (_ success: [Booking]) -> Void)
{
    
    var bookingsList = [Booking]()
    
    fetchAllBookingsIDsByItemID(item: id, category: cat, completion: { (booking_ids) -> Void in
        
        var count = 1

        for booking_id in booking_ids
        {
            fetchBookings(by: booking_id, completion: { (fetched_bookings) in
                for booking in fetched_bookings
                {
                    bookingsList.append(booking)

                    if(count==booking_ids.count)
                    {
                        completion(bookingsList)
                    }
                    count+=1;
                }
                
            })
        }
        
    })
    
}




func fetchAllBookingsIDsByUser(user_id user_id: String, completion: @escaping (_ success: [String]) -> Void)
{
    let ref = Database.database().reference().child("Users").child(user_id).child("bookings")
    
    var bookingsIDs = [String]()
    
    var count = 0
    
    ref.observe(.value, with: { (snapshot: DataSnapshot!) in
        //print(snapshot.childrenCount)
        
        ref.observe(DataEventType.childAdded) { (snap) in
            //print(snap.key)
            bookingsIDs.append(snap.key)
            count+=1
            if(count==snapshot.childrenCount)
            {
                completion(bookingsIDs)
            }
            
            
        }
    })
    
}

func fetchAllBookingsByUser(user_id user_id: String, completion: @escaping (_ succes: [Booking]) -> Void)
{
    
    
    var bookings = [Booking]()
    var count = 1
    
    fetchAllBookingsIDsByUser(user_id: Auth.auth().currentUser?.uid ?? "null") { (bks) in
        for bk in bks
        {
            let currentBooking = Booking()

            let ref = Database.database().reference().child("Bookings")
            let pathToBooking = ref.child(bk)
            
            pathToBooking.observeSingleEvent(of: .value, with: { (snap) in
                
                currentBooking.category = snap.childSnapshot(forPath: "categoryId").value as! String
                currentBooking.description = snap.childSnapshot(forPath: "descriere").value as! String
                currentBooking.user = snap.childSnapshot(forPath: "user").value as! String
                currentBooking.itemId = snap.childSnapshot(forPath: "itemId").value as! String
                currentBooking.itemName = snap.childSnapshot(forPath: "itemName").value as! String
                currentBooking.startDate = snap.childSnapshot(forPath: "interval").childSnapshot(forPath: "from").value as! String
                currentBooking.endDate = snap.childSnapshot(forPath: "interval").childSnapshot(forPath: "till").value as! String
                currentBooking.id = snap.key
                
                bookings.append(currentBooking)
                
                print(currentBooking.category)
                if(count==bks.count)
                {
                    completion(bookings)
                }
                count+=1
            })
            

        }
    }
}
