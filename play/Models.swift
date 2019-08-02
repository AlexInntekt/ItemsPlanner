//
//  Models.swift
//  
//
//  Created by Alexandru-Mihai Manolescu on 17/07/2019.
//

import Foundation

//class User {
//    var email = ""
//    var uid = ""
//}

class Booking {
    var description = String()
    var category = String()
    var itemId = String()
    var itemName = String()
    var user = String()
    var startDate = String()
    var endDate = String()
    
}

class Item {
    var category = String()
    var id = String()
    var description = String()
    var image_url = String()
    var name = String()
    var bookings = [Booking]()
}
