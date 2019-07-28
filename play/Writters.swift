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
