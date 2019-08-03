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

class PanouPrimire: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource
{
    
    @IBOutlet var pickerCategory: UIPickerView!
    
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
    

    @IBOutlet var adminButton: UIButton!
    @IBAction func adminButton(_ sender: Any)
    {
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
        
        self.itemsTableView.delegate = self
        self.itemsTableView.dataSource = self
        self.pickerCategory.delegate = self
        self.pickerCategory.dataSource = self
        
        print("PanouPrimire este in deschis")
        
        setupUI()
        loadDataFromDB()
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
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
    
    func setupUI()
    {
        
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
}
