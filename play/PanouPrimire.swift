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

var displayingItems = [Item]()
var displayingCategories = ["Toate"]

var displayingMenu = false

class PanouPrimire: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource
{
    
    @IBOutlet var menu: UIView!
    
    @IBOutlet var faderView: UIView!
    @IBOutlet var leadingConstraintMenu: NSLayoutConstraint!
    
    @IBOutlet var leadingConstraintFaderView: NSLayoutConstraint!
    
    
    @IBOutlet var pickerCategory: UIPickerView!
    
    @IBOutlet var itemsTableView: UITableView!
    
    @IBOutlet weak var welcomeLabel: UILabel!
    
    
    @IBOutlet var goToSeeMyBookings: UIButton!
    @IBAction func goToSeeMyBookings(_ sender: Any)
    {
        triggerMenu()
        self.performSegue(withIdentifier: "myBookingsSegue", sender: nil)
    }
    
    @IBOutlet var menuButton: UIButton!
    @IBAction func menuButton(_ sender: Any)
    {
        triggerMenu()
        
    }
    
    func triggerMenu()
    {
        
        if(!displayingMenu)
        {
            self.leadingConstraintFaderView.constant = 0
            self.faderView.alpha=0
            
            self.view.layoutIfNeeded()
            
            self.leadingConstraintMenu.constant = 0
            
            UIView.animate(withDuration: 0.6) {
                self.faderView.alpha=0.5
                self.view.layoutIfNeeded()
            }
        }
        else
        {
            self.leadingConstraintFaderView.constant = +1000
            self.faderView.alpha=0.5
            
            self.view.layoutIfNeeded()
            
            self.leadingConstraintMenu.constant = -500
            
            UIView.animate(withDuration: 0.6) {
                self.faderView.alpha=0
                self.view.layoutIfNeeded()
            }
            
        }
        
        
        
        displayingMenu = !displayingMenu
    }
    
    @IBOutlet weak var logout: UIButton!
    @IBAction func logout(_ sender: Any)
    {
        triggerMenu()
        
        do{
            try Auth.auth().signOut()
        } catch{
            
        }
        
        performSegue(withIdentifier: "logoutSegue", sender: nil)
    }
    

    @IBOutlet var adminButton: UIButton!
    @IBAction func adminButton(_ sender: Any)
    {
        triggerMenu()
        self.performSegue(withIdentifier: "adminSegue", sender: nil)
    }
    
    
    
    func showSimpleAlert(message: String) {
        let alert = UIAlertController(title: "Signing in problem", message: message, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { _ in
            //Cancel Action
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 40
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return displayingCategories.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return displayingCategories[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        displayingItems.removeAll()
        
        if(displayingCategories[row]=="Toate")
        {
            displayingItems=items
            self.itemsTableView.reloadData()
        }
        else
        {
            for item in items
            {
                if(item.category==displayingCategories[row])
                {
                    displayingItems.append(item)
                }
            }
            
            self.itemsTableView.reloadData()
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return displayingItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = self.itemsTableView.dequeueReusableCell(withIdentifier: "TBVCell") as! TBVCell
        let item = displayingItems[indexPath.row]
        cell.labelName?.text = item.name
        cell.labelDescription?.text = item.description
        cell.labelCategory?.text = "categorie: \(item.category)"
        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        self.performSegue(withIdentifier: "goToCalendar", sender: displayingItems[indexPath.row])
    }
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        detectChanges()
        
        self.itemsTableView.delegate = self
        self.itemsTableView.dataSource = self
        self.pickerCategory.delegate = self
        self.pickerCategory.dataSource = self
        
        print("PanouPrimire este in deschis")
        
        loadDataFromDB()
        
        
        // The didTap: method will be defined in Step 3 below.
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTap(sender:)))
        
        // Optionally set the number of required taps, e.g., 2 for a double click
        tapGestureRecognizer.numberOfTapsRequired = 1
        
        // Attach it to a view of your choice. If it's a UIImageView, remember to enable user interaction
        faderView.isUserInteractionEnabled = true
        faderView.addGestureRecognizer(tapGestureRecognizer)

        setupLogic()
        
 
    }
    
    @objc func didTap(sender: UITapGestureRecognizer) {
        let location = sender.location(in: view)
        // User tapped at the point above. Do something with that if you want.
        triggerMenu()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupUI()
        if Auth.auth().currentUser != nil {
            welcomeLabel.text="Bine ai venit, \(Auth.auth().currentUser!.displayName!)!"
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
    
    func setupLogic()
    {
        let ref = Database.database().reference()
        
        
        let path = ref.child("Users").child((Auth.auth().currentUser?.uid)!).child("isAdmin")
        
        path.observeSingleEvent(of: .value) { (snap) in
            let value = snap.value as? String
            
            if let value = value
            {
                if(value=="true")
                {
                    self.adminButton.isHidden=false
                }
                else
                {
                    self.adminButton.isHidden=true
                }
            }
        }
        
    }
    
   
    
    func setupUI()
    {
        self.leadingConstraintMenu.constant = -400
        self.leadingConstraintFaderView.constant = 1000
    }
    
    func loadDataFromDB()
    {
        items.removeAll()
        
        fetchAllItems(completion: { (fetched_items) -> Void in
            
            for item in fetched_items
            {
                items.append(item)
            }
            
            displayingItems=items
            self.itemsTableView.reloadData()
            
            
            fetchAllCategories(completion: { (categories) in
                displayingCategories.append(contentsOf: categories)
                
                self.pickerCategory.reloadAllComponents()
                
            })
            
        })
    }
    
    
    func detectChanges()
    {
        
        
        let ref = Database.database().reference().child("Users").child((Auth.auth().currentUser?.uid)!).child("bookings")
        
        
        ref.observe(.value, with: { (snapshot: DataSnapshot!) in
            //print(snapshot.childrenCount)
            
            ref.observe(DataEventType.childAdded) { (snap) in
                //print(snap.key)
                
              
                
            }
        })
        
    }
    
}
