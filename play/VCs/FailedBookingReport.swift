//
//  FailedBookingReport.swift
//  play
//
//  Created by Alexandru-Mihai Manolescu on 07/08/2019.
//  Copyright © 2019 Alexandru-Mihai Manolescu. All rights reserved.
//

import Foundation
import UIKit

class FailedBookingReport: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    var reports = [FailedBookingReportModel]()
    var desiredItem = Item()
    var editmode = false
    var existingBookingToModify = Booking()
    var cacheBooking = Booking()
    var cache = true
    
    @IBOutlet var tbv: UITableView!
    
   
    @IBAction func back(_ sender: Any)
    {
        self.performSegue(withIdentifier: "backToCalendar", sender: nil)
    }
    
    override func viewDidLoad() {
        self.tbv.delegate = self
        self.tbv.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
         let cell = self.tbv.dequeueReusableCell(withIdentifier: "FailReportCell") as! FailReportCell
             cell.usernameLabel?.text=reports[indexPath.row].username
             cell.phoneNumberLabel?.text=reports[indexPath.row].phone
        cell.infoLabel?.text="\(reports[indexPath.row].date) \n Cantitate: \(reports[indexPath.row].quantity) \n Scop rezervare: \(reports[indexPath.row].description)"
        return cell
    }
    
//    let cell = self.itemsTableView.dequeueReusableCell(withIdentifier: "TBVCell") as! TBVCell
//    let item = displayingItems[indexPath.row]
//    cell.labelName?.text = item.name
//    cell.labelDescription?.text = item.description
//    cell.labelCategory?.text = "categorie: \(item.category)"
//    return cell;
//
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reports.count
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: (Any)?)
    {
        if(segue.identifier=="backToCalendar")
        {
           
            let defVC = segue.destination as! BookItemVC
            defVC.currentItem = desiredItem
            defVC.editMode = self.editmode
            defVC.existingBookingToModify = self.existingBookingToModify.copy()
            defVC.cacheBooking = self.cacheBooking.copy()
            defVC.cache = self.cache
        }
        
        
    }
    
}
