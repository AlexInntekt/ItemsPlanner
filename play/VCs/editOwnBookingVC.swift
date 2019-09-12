//
//  editOwnBookingVC.swift
//  play
//
//  Created by Alexandru-Mihai Manolescu on 10/08/2019.
//  Copyright © 2019 Alexandru-Mihai Manolescu. All rights reserved.
//

import Foundation
import UIKit

class editOwnBookingVC: UIViewController, UITextFieldDelegate, UITextViewDelegate
{
    
    @IBOutlet weak var item: UILabel!
    
    @IBOutlet weak var bookingDescr: UITextView!
    
    @IBOutlet weak var date: UILabel!
    
    var currentBooking=Booking()
    
  
    @IBOutlet weak var save: UIButton!
    
    @IBAction func save(_ sender: Any)
    {
        let newDescription = self.bookingDescr.text ?? ""
    reference.child("Bookings").child(currentBooking.id).updateChildValues(["descriere":newDescription]) { (error, reference) in
            if(error != nil)
            {
                alert(UIVC: self, title: "Eroare", message: "\(error)")
            }
            else
            {
                self.performSegue(withIdentifier: "back", sender: nil)
            }
        }
    }
    
    @IBAction func changeDate(_ sender: Any)
    {
        self.performSegue(withIdentifier: "editDateOfOwnBookingSegue", sender: nil)
    }
    
    override func viewDidLoad()
    {
        item.text="Obiect: \(currentBooking.itemName)"
        bookingDescr.text=currentBooking.description
        var text = "\(currentBooking.startDate) - \(currentBooking.endDate) \n"
        text += "Cantitate: \(currentBooking.quantity)"
        date.text = text
        
        bookingDescr.delegate = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: (Any)?)
    {
        if(segue.identifier=="editDateOfOwnBookingSegue")
        {
            
            let defVC = segue.destination as! EditDateOfOwnBookingVC
            defVC.currentBooking = self.currentBooking
            
        }
    }
    
    /* Updated for Swift 4 */
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    /* Older versions of Swift */
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}
