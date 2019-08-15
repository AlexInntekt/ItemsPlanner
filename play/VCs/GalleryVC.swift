//
//  GalleryVC.swift
//  play
//
//  Created by Alexandru-Mihai Manolescu on 15/08/2019.
//  Copyright © 2019 Alexandru-Mihai Manolescu. All rights reserved.
//

import Foundation
import UIKit

class GalleryVC: UIViewController
{
    var currentItem = Item()
    var descriptionOfBooking = ""
    
    @IBAction func back(_ sender: Any)
    {
        performSegue(withIdentifier: "back", sender: nil)
    }
    
    override func viewDidLoad()
    {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if(segue.identifier=="back")
        {
            let defVC = segue.destination as! BookItemVC
            defVC.currentItem = self.currentItem
            defVC.descriptionOfBooking = self.descriptionOfBooking
        }
    }
    
    
}
