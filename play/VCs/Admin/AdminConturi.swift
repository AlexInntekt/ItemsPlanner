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
    var accountEmails:[(key: String, name: String)] = []
    var path = Database.database().reference()
    
    @IBOutlet weak var tbv: UITableView!
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return accountEmails.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = UITableViewCell()
        cell.textLabel!.text = accountEmails[indexPath.row].name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let delete = UITableViewRowAction(style: .destructive, title: "Șterge") { (action, indexPath) in
            
            let title = "Confirmare"
            let message = "Această acțiune nu va șterge contul, însă va dezactiva permisiunea de logare si creare cont pe acest email. Puteți oricând readăuga adresa în această listă."
            let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Nu, anulează", style: UIAlertAction.Style.cancel, handler: { _ in
            }))
            alert.addAction(UIAlertAction(title: "Da, șterge", style: UIAlertAction.Style.destructive, handler: { _ in
                
                self.path.child(self.accountEmails[indexPath.row].key).removeValue()
            }))
            
            self.present(alert, animated: true)
        }
        
        return [delete]
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
                let email = snap.value as! String
                let key = snap.key as! String
                
                self.accountEmails.append((key: key, name:email))
            }
            
            self.tbv.reloadData()
        }
    }
}
