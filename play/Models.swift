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
    
    init(){}
    
    init(_ id: String,
         _ description: String,
         _ category: String,
         _ itemId: String,
         _ itemName: String,
         _ user: String,
         _ startDate: String,
         _ endDate: String,
         _ quantity: Int)
    {
        self.id = id;
        self.description = description;
        self.category = category;
        self.itemId = itemId;
        self.itemName = itemName;
        self.user = user;
        self.startDate = startDate;
        self.endDate = endDate;
        self.quantity = quantity
    }
    
    func copy()->Booking
    {
        let copy = Booking(self.id,
                        self.description,
                        self.category,
                        self.itemId,
                        self.itemName,
                        self.user,
                        self.startDate,
                        self.endDate,
                        self.quantity)
        return copy
    }
    
}

class BookingPack {
    var id = String()
    var description = String()
    var descriptionOfItem = String()
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
    init(_ catn: String,
         _ catid: String,
         _ id: String,
         _ descr: String,
         _ imgurl: String,
         _ name: String,
         _ bks: [Booking],
         _ imgs: [FBImage],
         _ q: Int)
    {
        self.category_name = catn
        self.category_id = catid
        self.id = id
        self.description = descr
        self.image_url = imgurl
        self.name = name
        self.bookings = bks
        self.images = imgs
        self.quantity = q
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
    
    func copy()->Item
    {
        let copy = Item(self.category_name, self.category_id, self.id, self.description, self.image_url, self.name, self.bookings, self.images, self.quantity)
        return copy
    }
}


class FailedBookingReportModel {
    var username=""
    var date=""
    var phone=""
    var quantity=""
    var description=""
}


class FBImage {
    var url = String()
    var uid = String()
    var accesid = String()
}
