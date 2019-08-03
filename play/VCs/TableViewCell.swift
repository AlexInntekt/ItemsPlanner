//
//  TableViewCell.swift
//  play
//
//  Created by Alexandru-Mihai Manolescu on 28/07/2019.
//  Copyright © 2019 Alexandru-Mihai Manolescu. All rights reserved.
//

import Foundation
import UIKit

class TBVCell: UITableViewCell
{

    @IBOutlet weak var labelName: UILabel!
    
    @IBOutlet var labelDescription: UILabel!
    
    @IBOutlet var labelCategory: UILabel!
}


class TBVBookingCell: UITableViewCell
{
   
    @IBOutlet var itemName: UILabel!
    
    @IBOutlet var labelName: UITextView!
}
