//
//  ViewController.swift
//  play
//
//  Created by Alexandru-Mihai Manolescu on 12/07/2019.
//  Copyright © 2019 Alexandru-Mihai Manolescu. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

var list=["banana","portocala","ciucamba"]




class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        cell.textLabel?.text = list[indexPath.row]
        return cell;
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tbv1.dataSource = self
        tbv1.delegate = self
        

        let ref = Database.database().reference(withPath: "items")
        let elem = ref.child("balon_rosu").child("intervals").child("2")
        
        elem.setValue("12-26 August")
        

        
        
        //ref.child("items").child("balon_rosu").setValue("maaaa")
    }
    
    @IBOutlet weak var bt1: UIButton!
    @IBAction func bt1(_ sender: Any)
    {
        
    }

    @IBOutlet weak var tbv1: UITableView!
    
}

