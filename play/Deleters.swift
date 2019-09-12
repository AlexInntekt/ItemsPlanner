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


func deleteBookingWithIdAndUser(bk_id bk_id: String, item_id item_id: String, cat cat: String, userid userid: String)
{
    
    let ref = Database.database().reference()
    var child = ref.child("Bookings").child(bk_id)
    child.removeValue()
    
    
    //second block to make changes here:
    child = ref.child("Categories").child(cat).child("items").child(item_id).child("bookings").child(bk_id)
    child.removeValue()
    
    
    
    //    //third block to make changes:
    child = ref.child("Users").child(userid).child("bookings").child(bk_id)
    child.removeValue()
    
}


func deleteAllBookingsOfItem(_ item: Item)
{
        print("deleteAllBookingsOfItem() with param: ", item)
     reference.child("Categories").child(item.category_id).child("items").child(item.id).child("bookings").observeSingleEvent(of: .value) { (list) in
        
        for snap in list.children.allObjects as! [DataSnapshot]
        {
            let bid = snap.key as! String
            
            reference.child("Bookings").child(bid).observeSingleEvent(of: .value, with: { (bk) in
                
                print(bk)
                
                let userid = bk.childSnapshot(forPath: "user").value as! String

                reference.child("Bookings").child(bid).removeValue()
            reference.child("Users").child(userid).child("bookings").child(bid).removeValue()
            })
        }
        
        
        
    }
}



func deleteItem(_ item: Item)
{
    let itemToDelete=item
    let ref=Database.database().reference()
    let path_to_storage = Storage.storage().reference().child("images")
    
    //first delete its bookings:
    deleteAllBookingsOfItem(itemToDelete)
    
    //delete its images:
    for image in itemToDelete.images
    {
        path_to_storage.child(image.uid).delete(completion: { (error) in
            print(error, error.debugDescription)
        })
    }
    
    //delete its child:
    let path_of_item=ref.child("Categories").child(itemToDelete.category_id).child("items").child(itemToDelete.id)
    path_of_item.removeValue()
}
