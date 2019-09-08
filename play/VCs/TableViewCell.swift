//
//  TableViewCell.swift
//  play
//
//  Created by Alexandru-Mihai Manolescu on 28/07/2019.
//  Copyright © 2019 Alexandru-Mihai Manolescu. All rights reserved.
//

import Foundation
import UIKit
import JTAppleCalendar

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


class DateCell: JTACDayCell {
    
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var selectedView: UIView!
    
    
    
}


class AdminBookingCell: UITableViewCell
{

    @IBOutlet weak var itemNameLabel: UILabel!
  
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var itsDescription: UITextView!
    
}


class AdminItemCell: UITableViewCell
{
    @IBOutlet weak var itemNameLabel: UILabel!
    
    @IBOutlet weak var categoryLabel: UILabel!
    
    @IBOutlet weak var descriptionTextView: UITextView!
}


class ImageCell: UICollectionViewCell
{
    @IBOutlet weak var image: UIImageView!
}
