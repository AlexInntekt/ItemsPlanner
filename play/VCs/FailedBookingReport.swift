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
    var report = [FailedBookingReport]()
    var desiredItem = [Item]()
    
    @IBOutlet var tbv: UITableView!
    
    
    override func viewDidLoad() {
        self.tbv.delegate = self
        self.tbv.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
         let cell = self.tbv.dequeueReusableCell(withIdentifier: "FailReportCell") as! FailReportCell
             cell.usernameLabel?.text="tu"
             cell.phoneNumberLabel?.text="587129537"
             cell.dateLabel?.text="maine"
        return UITableViewCell()
    }
    
//    let cell = self.itemsTableView.dequeueReusableCell(withIdentifier: "TBVCell") as! TBVCell
//    let item = displayingItems[indexPath.row]
//    cell.labelName?.text = item.name
//    cell.labelDescription?.text = item.description
//    cell.labelCategory?.text = "categorie: \(item.category)"
//    return cell;
//
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
}
