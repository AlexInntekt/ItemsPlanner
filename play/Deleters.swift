//
//  Deleters.swift
//  
//
//  Created by Alexandru-Mihai Manolescu on 02/08/2019.
//

import Foundation
import Firebase
import FirebaseDatabase

func deleteMyBookingWithId(bk_id bk_id: String, item_id item_id: String, cat cat: String)
{
    
    let ref = Database.database().reference()
    var child = ref.child("Bookings").child(bk_id)
    child.removeValue()


    
    //second block to make changes here:
    child = ref.child("Categories").child(cat).child("items").child(item_id).child("bookings").child(bk_id)
    child.removeValue()
    
    
    
//    //third block to make changes:
    child = ref.child("Users").child((Auth.auth().currentUser?.uid)!).child("bookings").child(bk_id)
    child.removeValue()
    
}
