//
//  editOwnBookingVC.swift
//  play
//
//  Created by Alexandru-Mihai Manolescu on 10/08/2019.
//  Copyright © 2019 Alexandru-Mihai Manolescu. All rights reserved.
//

import Foundation
import UIKit

class editOwnBookingVC: UIViewController
{
    
    @IBOutlet weak var item: UILabel!
    
    @IBOutlet weak var bookingDescr: UITextView!
    
    @IBOutlet weak var date: UILabel!
    
    var currentBooking=Booking()
    
    @IBAction func changeDate(_ sender: Any)
    {
        self.performSegue(withIdentifier: "editDateOfOwnBookingSegue", sender: nil)
    }
    
    override func viewDidLoad()
    {
        item.text="Rezervare \(currentBooking.itemName)"
        bookingDescr.text=currentBooking.description
        date.text="\(currentBooking.startDate) - \(currentBooking.endDate)"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: (Any)?)
    {
        if(segue.identifier=="editDateOfOwnBookingSegue")
        {
            
            let defVC = segue.destination as! EditDateOfOwnBookingVC
            defVC.currentBooking = self.currentBooking
            
        }
    }
}
