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
    var descriptionOfBooking = ""
    
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
             cell.dateLabel?.text=reports[indexPath.row].date
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
            defVC.descriptionOfBooking = descriptionOfBooking
        }
        
        
    }
    
}
