//
//  AdminItemsVC.swift
//  play
//
//  Created by Alexandru-Mihai Manolescu on 10/08/2019.
//  Copyright © 2019 Alexandru-Mihai Manolescu. All rights reserved.
//

import Foundation
import UIKit

class AdminItemsVC: UIViewController,UITableViewDelegate, UITableViewDataSource
{
    var displayingItems=[Item]()
    var items=[Item]()
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayingItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tbv.dequeueReusableCell(withIdentifier: "AdminItemCell") as! AdminItemCell
            cell.itemNameLabel?.text=displayingItems[indexPath.row].name
            cell.categoryLabel?.text=displayingItems[indexPath.row].category
            cell.descriptionTextView?.text=displayingItems[indexPath.row].description
        return cell;
    }
    
    
    @IBOutlet weak var tbv: UITableView!
    
    override func viewDidLoad()
    {
        self.tbv.delegate=self
        self.tbv.dataSource=self
    }
}
