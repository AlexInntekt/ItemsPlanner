//
//  AdminConturi.swift
//  play
//
//  Created by Alexandru-Mihai Manolescu on 15/09/2019.
//  Copyright © 2019 Alexandru-Mihai Manolescu. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class AdminConturi: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    
    var accountEmails = [String]()
    var path = Database.database().reference()
    
    @IBOutlet weak var tbv: UITableView!
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return accountEmails.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = UITableViewCell()
        cell.textLabel!.text = accountEmails[indexPath.row]
        
        return cell
    }
    
    
    
    override func viewDidLoad()
    {
        self.tbv.delegate = self
        self.tbv.dataSource = self
        
        path = Database.database().reference().child("UsersEmail")
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        loadDataFromDB()
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        path.removeAllObservers()
    }
    
    func loadDataFromDB()
    {
        path.observe(.value) { (list) in
            self.accountEmails.removeAll()
            for snap in list.children.allObjects as! [DataSnapshot]
            {
                let femail = snap.value as! String
                print(femail)
                
                self.accountEmails.append(femail)
            }
            
            self.tbv.reloadData()
        }
    }
}
