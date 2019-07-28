//
//  Writters.swift
//  play
//
//  Created by Alexandru-Mihai Manolescu on 28/07/2019.
//  Copyright © 2019 Alexandru-Mihai Manolescu. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

func createItem(item item: Item, byCategory cat: String, with_item_id id: String)
{
    let ref = Database.database().reference()
    let db = ref.child("Categories").child(cat).child("items")
    
    
    db.setValue(id)
    db.child(id).updateChildValues(["name": item.name])
    db.child(id).updateChildValues(["image_url": item.image_url])
    db.child(id).updateChildValues(["descriere": item.description])
}


func addBooking(item id: String, of_user user: String, description descr: String, in_category cat: String, startdate sd: String, enddate ed: String)
{
    
    let ref = Database.database().reference()
    var db = ref.child("Bookings")
    
    let new = db.childByAutoId()
    let interval = {["from":sd];["till":ed]}
    new.updateChildValues(["descriere":descr])
    new.child("interval").updateChildValues(["from":sd])
    new.child("interval").updateChildValues(["till":ed])
    new.updateChildValues(["user":user])
    
    let keyToBooking = new.key!
    
    
    //second block to make changes here:
    db = ref.child("Categories").child(cat).child("items")
    db.child(id).child("bookings").updateChildValues([keyToBooking: keyToBooking])
    
    //        db.child(id).child("bookings").updateChildValues([bid: bid])
    
    
    
    
    
    
//    db.updateChildValues([bid:""])
//    db.child(bid).setValue("interval")
//    db.child(bid).updateChildValues(["descriere":descr])
//    db.child(bid).updateChildValues(["user":user])
//
//    let interval = {["from":sd];["till":ed]}
//
//    db.child(bid).updateChildValues(["interval" : interval])
//    db.child(bid).child("interval").updateChildValues(["from":sd])
//    db.child(bid).child("interval").updateChildValues(["till":ed])
//
}
