//
//  PanouPrimire.swift
//  
//
//  Created by Alexandru-Mihai Manolescu on 14/07/2019.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

var items = [Item]()

class PanouPrimire: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    
    
    
    @IBOutlet var itemsTableView: UITableView!
    
    @IBOutlet weak var welcomeLabel: UILabel!
    
    @IBOutlet weak var logout: UIButton!
    @IBAction func logout(_ sender: Any)
    {
        do{
            try Auth.auth().signOut()
        } catch{
            
        }
        
        performSegue(withIdentifier: "logoutSegue", sender: nil)
    }
    
    func showSimpleAlert(message: String) {
        let alert = UIAlertController(title: "Signing in problem", message: message, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { _ in
            //Cancel Action
        }))
        
        self.present(alert, animated: true, completion: nil)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = self.itemsTableView.dequeueReusableCell(withIdentifier: "TBVCell") as! TBVCell
        cell.labelName?.text = items[indexPath.row].name
        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        self.performSegue(withIdentifier: "goToCalendar", sender: items[indexPath.row])
    }
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.itemsTableView.delegate = self
        self.itemsTableView.dataSource = self
        
        print("PanouPrimire este in deschis")
        
        setupUI()
        loadItemsFromDB()
        
        
        
        
        fetchAllBookingsByItemID(item: "I1", category: "C1", completion: { (bookings) -> Void in
            
            
            for obj in bookings
            {
                print(obj)
            }
            
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if Auth.auth().currentUser != nil {
            welcomeLabel.text="Bine ai venit, \(Auth.auth().currentUser!.displayName!)"
            //showSimpleAlert(message: "user")
            //showSimpleAlert(message: Auth.auth().currentUser!.displayName!)
        } else {
            showSimpleAlert(message: "error")
        }
        
       // test_fetch_all_items()
        
//        let item=Item()
//            item.name="Viermisor dulce"
//            item.description="No comment!"
//            item.image_url="Nu are asa ceva"
//
        //createItem(item: item, byCategory: "C3", with_item_id: "I10")
        
        
//        addBooking(item: "I2", of_user: "Alex", description: "Booking testare facut de Alex", in_category: "C1",  startdate: "2019 07 28", enddate: "2019 07 29")
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: (Any)?)
    {
        if(segue.identifier=="goToCalendar")
        {
            let obj = sender as! Item
            let defVC = segue.destination as! BookItemVC
            defVC.currentItem = obj
           
        }
        
        
    }
    
    func setupUI()
    {
        
    }
    
    func loadItemsFromDB()
    {
        items.removeAll()
        
        fetchAllItems(completion: { (fetched_items) -> Void in
            
            for item in fetched_items
            {
                items.append(item)
            }
            
            self.itemsTableView.reloadData()
            
        })
    }
}
