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
    var id = String()
    var description = String()
    var category = String()
    var itemId = String()
    var itemName = String()
    var user = String()
    var startDate = String()
    var endDate = String()
    var quantity = Int()
    
}

class BookingPack {
    var id = String()
    var description = String()
    var category_id = String()
    var category_name = String()
    var itemId = String()
    var itemName = String()
    var user = String()
    var startDate = String()
    var endDate = String()
    var phone = String()
    var username = String()
}

class Item {
    init(name setName: String, description setDescription: String)
    {
        self.name = setName
        self.description = setDescription
    }
    init(){}
    var category_name = String()
    var category_id = String()
    var id = String()
    var description = String()
    var image_url = String()
    var name = String()
    var bookings = [Booking]()
    var images = [FBImage]()
    var quantity = Int()
}


class FailedBookingReportModel {
    var username=""
    var date=""
    var phone=""
}


class FBImage {
    var url = String()
    var uid = String()
}
