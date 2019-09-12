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
import FirebaseAuth

func createItem(item item: Item, byCategory cat: String)
{
    let ref = Database.database().reference()
    

    let db = ref.child("Categories").child(cat).child("items")
    
    db.childByAutoId()
    let id = db.childByAutoId().key as! String
    
    let dict = ["name": item.name,"image_url": item.image_url,"descriere": item.description]
//        db.child(id).updateChildValues(["name": item.name])
//        db.child(id).updateChildValues(["image_url": item.image_url])
//        db.child(id).updateChildValues(["descriere": item.description])
    
    db.child(id).setValue(dict)
    
    
}


func addBooking(itemName itemName: String, item id: String, of_user_id user_id: String, description descr: String, in_category_name cat_name: String, in_category_id cat_id: String, startdate sd: String, enddate ed: String, quantity quantity: Int, editmode editmode: Bool, bookingid bookingid: String)
{
    
//    reference.child("Bookings").runTransactionBlock { (currentData: MutableData) -> TransactionResult in
//        if var data = currentData.value as? [String: Any] {
////            var count = data["count"] as? Int ?? 0
////            count += 1
////            data["count"] = count
////
////            currentData.value = data
//
//            let new = reference.child("Bookings").childByAutoId().key as! String
//            let interval = {["from":sd];["till":ed]}
//            let dict = {["cantitate":quantity];
//                ["descriere":descr];
//                ["itemId":id];
//                ["categoryId":cat_id];
//                ["categoryName":cat_name];
//                ["itemName":itemName];
//                ["interval":interval]
//            }
//
//            data[new]=dict
//            currentData.value=data
//        }
//
//        return TransactionResult.success(withValue: currentData)
//    }
    
    let ref = Database.database().reference()
    var db = ref.child("Bookings")

   

    let block: [String : Any] = [
        "cantitate" : quantity,
        "descriere" : descr,
        "itemId": id,
        "categoryId" : cat_id,
        "categoryName" : cat_name,
        "itemName": itemName,
        "interval": ["from":sd,"till":ed],
        "user":user_id
    ]

    var keyToBooking = String()
    if(editmode)
    {
        keyToBooking = String(bookingid)
    }
    else
    {
        let new = db.childByAutoId()
        keyToBooking = new.key! as String
    }
    
    
    db.updateChildValues([keyToBooking:block])

    //second block to make changes here:
    db = ref.child("Categories").child(cat_id).child("items")
    db.child(id).child("bookings").updateChildValues([keyToBooking: keyToBooking])


    //third block to make changes:
    db = ref.child("Users").child((Auth.auth().currentUser?.uid)!).child("bookings")
    db.updateChildValues([keyToBooking:keyToBooking])


}


