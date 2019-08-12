//
//  EditDateOfOwnBookingVC.swift
//  play
//
//  Created by Alexandru-Mihai Manolescu on 12/08/2019.
//  Copyright © 2019 Alexandru-Mihai Manolescu. All rights reserved.
//

import Foundation
import UIKit

class EditDateOfOwnBookingVC: UIViewController
{
    var currentBooking = Booking()
    
    @IBOutlet weak var EditDateOfOwnBookingVC: UIButton!
    
    @IBAction func EditDateOfOwnBookingVC(_ sender: Any)
    {
        self.performSegue(withIdentifier: "BackToeditDateOfOwnBookingSegue", sender: nil)
    }
    
    override func viewDidLoad()
    {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: (Any)?)
    {
        if(segue.identifier=="BackToeditDateOfOwnBookingSegue")
        {
            let obj = sender as! Booking
            let defVC = segue.destination as! EditDateOfOwnBookingVC
            defVC.currentBooking = obj
            
        }
    }
}
