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

let reference = Database.database().reference()
let categoriesRef=reference.child("Categories")

var shouldShowSearchResults = false

class PanouPrimire: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource, UISearchBarDelegate
{
    
    

    
    
    var searchBar: UISearchBar!
    
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
    
    @IBAction func panouPrincipalButton(_ sender: Any)
    {
        triggerMenu()
    }
    
    
    @IBAction func despreButton(_ sender: Any)
    {
        triggerMenu()
        self.performSegue(withIdentifier: "aboutVCSegue", sender: nil)
    }
    
    
    @IBAction func myAccountButton(_ sender: Any)
    {
        triggerMenu()
        self.performSegue(withIdentifier: "myProfile", sender: nil)
    }
    
    
    
  
    func configureSearchController() {
        // Initialize and perform a minimum configuration to the search controller.
        searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: 200, height: 20))
        
//        searchController.dimsBackgroundDuringPresentation = false
        searchBar.placeholder = "Cautare generală"
        searchBar.delegate = self
        searchBar.sizeToFit()
        
        // Place the search bar view to the tableview headerview.
        itemsTableView.tableHeaderView = searchBar
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar)
    {
        shouldShowSearchResults = true
        displayingItems.sort(by: { $0.name < $1.name })
        itemsTableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar)
    {
        print("searchBarCancelButtonClicked")
        searchBar.resignFirstResponder()
        shouldShowSearchResults = false
        displayingItems.sort(by: { $0.name < $1.name })
        itemsTableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if !shouldShowSearchResults {
            shouldShowSearchResults = true
            displayingItems.sort(by: { $0.name < $1.name })
            itemsTableView.reloadData()
        }
        print("searchBarSearchButtonClicked")
        
        searchBar.resignFirstResponder()
    }
    
    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        self.pickerCategory.selectRow(0, inComponent: 0, animated: false)
        
        let searchString = searchBar.text
        displayingItems = items.filter({( item : Item) -> Bool in
            let block = item.name.lowercased().contains(searchString!.lowercased()) ||
                        item.description.lowercased().contains(searchString!.lowercased()) ||
                        item.category_name.lowercased().contains(searchString!.lowercased())
            return block
        })
        
        if(searchText=="")
        {
            displayingItems=items
            shouldShowSearchResults=false
        }
        
        if searchBar.text == nil || searchBar.text == ""
        {
            searchBar.perform(#selector(self.resignFirstResponder), with: nil, afterDelay: 0.1)
        }
        
        displayingItems.sort(by: { $0.name < $1.name })
        itemsTableView.reloadData()
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
        
        let title = "Ieșire din cont"
        let message = "Sigur doriți să ieșiți din cont?"
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Nu, anulează", style: UIAlertAction.Style.cancel, handler: { _ in
        }))
        alert.addAction(UIAlertAction(title: "Da, ies", style: UIAlertAction.Style.destructive, handler: { _ in
            do{
                try Auth.auth().signOut()
            } catch{}
            GlobalCurrentUserName=""
            self.triggerMenu()
            self.performSegue(withIdentifier: "logoutSegue", sender: nil)
        }))
        
    
        self.present(alert, animated: true)
    }
    

    @IBOutlet weak var adminButtonRezervari: UIButton!
    @IBAction func adminButtonRezervari(_ sender: Any)
    {
        triggerMenu()
        self.performSegue(withIdentifier: "adminBookingsSegue", sender: nil)
    }
    
    @IBOutlet weak var adminTitle: UILabel!
    
    @IBOutlet weak var adminButtonCategorii: UIButton!
    @IBAction func adminButtonCategorii(_ sender: Any)
    {
        triggerMenu()
        self.performSegue(withIdentifier: "adminCategoriesSegue", sender: nil)
    }
    
    
    @IBOutlet weak var adminButtonArticole: UIButton!
    @IBAction func adminButtonArticole(_ sender: Any)
    {
        triggerMenu()
        self.performSegue(withIdentifier: "adminItemsSegue", sender: nil)
        
    }
    
    
    @IBOutlet weak var adminConturi: UIButton!
    @IBAction func adminConturi(_ sender: Any)
    {
        triggerMenu()
        self.performSegue(withIdentifier: "adminConturiSegue", sender: nil)
        
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
        UserDefaults.standard.set(String(row), forKey: "selected_category")
        
        filterDisplayingItemsByCategory(displayingCategories[row])
        displayingItems.sort(by: { $0.name < $1.name })
        self.itemsTableView.reloadData()
        scrollToFirstRow(in: self.itemsTableView)
    }
    
    func filterDisplayingItemsByCategory(_ category: String)
    {
        displayingItems.removeAll()
        
        if(category=="Toate")
        {
            displayingItems=items
        }
        else
        {
            for item in items
            {
                if(item.category_name==category)
                {
                    displayingItems.append(item)
                }
            }

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
        cell.labelCategory?.text = "categorie: \(item.category_name)"
        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        self.performSegue(withIdentifier: "goToCalendar", sender: displayingItems[indexPath.row])
        
    }
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        enableBodyguard(UIVC:self)
        configureSearchController()
        
        self.itemsTableView.delegate = self
        self.itemsTableView.dataSource = self
        self.pickerCategory.delegate = self
        self.pickerCategory.dataSource = self
        
        print("PanouPrimire este in deschis")
        
        
        // The didTap: method will be defined in Step 3 below.
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTap(sender:)))
        
        // Optionally set the number of required taps, e.g., 2 for a double click
        tapGestureRecognizer.numberOfTapsRequired = 1
        
        // Attach it to a view of your choice. If it's a UIImageView, remember to enable user interaction
        faderView.isUserInteractionEnabled = true
        faderView.addGestureRecognizer(tapGestureRecognizer)
        
        //searchBar.showsCancelButton = true
    }
    
    
    
    @objc func didTap(sender: UITapGestureRecognizer) {
        let location = sender.location(in: view)
        // User tapped at the point above. Do something with that if you want.
        triggerMenu()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadDataFromDB()
        setupLogic()
        setupUI()
        if Auth.auth().currentUser != nil {
            
            if(GlobalCurrentUserName=="")
            {
                let uid = Auth.auth().currentUser?.uid as! String
                
                let referenceToUsers = Database.database().reference()
                
                referenceToUsers.child("Users").child(uid).observeSingleEvent(of: .value) { (val) in
                    
                    let dispName = val.childSnapshot(forPath: "name").value as! String
                    
                    GlobalCurrentUserName = dispName
                    self.welcomeLabel.text="Bine ai venit, \(GlobalCurrentUserName)!"
                }
            }
            else
            {
                self.welcomeLabel.text="Bine ai venit, \(GlobalCurrentUserName)!"
            }
            
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
                    self.adminButtonRezervari.isHidden=false
                    self.adminButtonCategorii.isHidden=false
                    self.adminButtonArticole.isHidden=false
                    self.adminTitle.isHidden=false
                    self.adminConturi.isHidden=false
                }
                else
                {
                    self.adminButtonRezervari.isHidden=true
                    self.adminButtonCategorii.isHidden=true
                    self.adminButtonArticole.isHidden=true
                    self.adminTitle.isHidden=true
                    self.adminConturi.isHidden=true
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
        
        categoriesRef.observe(.value) { (allCategories) in
            items.removeAll()
            displayingItems.removeAll()
            displayingCategories.removeAll()
            
            displayingCategories.append("Toate")
            
            for category in allCategories.children.allObjects as! [DataSnapshot]{
                let category_key = category.key
                let category_name = category.childSnapshot(forPath: "name").value as! String
                
                displayingCategories.append(category_name)
                
                let packets = category.childSnapshot(forPath: "items")
                //print(packets)
                
                for item in packets.children.allObjects as! [DataSnapshot]
                {
                      let currentItem = Item()
                    
                      if category.key != nil
                      {
                        currentItem.category_id = category_key
                        currentItem.category_name = category_name
                      }
                    
                      if item.hasChild("descriere")
                      {
                        currentItem.description = item.childSnapshot(forPath: "descriere").value as! String
                     }
                    
                      if item.hasChild("name")
                      {
                        currentItem.name = item.childSnapshot(forPath: "name").value as! String
                      }
                    
                     if item.hasChild("cantitate")
                     {
                        currentItem.quantity = item.childSnapshot(forPath: "cantitate").value as! Int
                     }
                    
//                      if item.childSnapshot(forPath: "bookings").value != nil
//                      {
//                         for bk in item.childSnapshot(forPath: "bookings").children.allObjects as! [DataSnapshot]
//                         {
//                            let booking = Booking()
//                                booking.category = 
//                            
//                            currentItem.bookings.append(bk)
//                         }
//                      }
                    
                      currentItem.id = item.key
                    
                      for image in item.childSnapshot(forPath: "images").children.allObjects as! [DataSnapshot]
                      {
//                        currentItem.image_url = imageurl.value as! String
                        //print(imageurl)
                        
                        
                        if((image.childSnapshot(forPath: "uid").exists()) && (image.childSnapshot(forPath: "url").exists()))
                        {
                            let fbimage = FBImage()
                            fbimage.uid = image.childSnapshot(forPath: "uid").value as! String
                            fbimage.url = image.childSnapshot(forPath: "url").value as! String
                            currentItem.images.append(fbimage)
                        }
                        
                        
                    }
                    
                      items.append(currentItem)
                }
            }
            
             self.pickerCategory.reloadAllComponents()
            
              if UserDefaults.standard.value(forKey: "selected_category") == nil
              {
                print("UserDefaults->selected_category is nill")
                UserDefaults.standard.set(self.pickerCategory.selectedRow(inComponent: 0), forKey: "selected_category")
                self.filterDisplayingItemsByCategory(displayingCategories[0])
              }
              else
              {
                //UserDefaults.standard.value(forKey: "selected_category")
                let saved_selection=UserDefaults.standard.integer(forKey: "selected_category")
                self.pickerCategory.selectRow(saved_selection, inComponent: 0, animated: false)
                
                if(!displayingCategories.isEmpty)
                {
                   
                    if(displayingCategories.count>=saved_selection)
                    {
                    self.filterDisplayingItemsByCategory(displayingCategories[saved_selection])
                    }
                    
                }
                
             }
            
            displayingItems.sort(by: { $0.name < $1.name })
            self.itemsTableView.reloadData()
            scrollToFirstRow(in: self.itemsTableView)
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        reference.removeAllObservers()
        categoriesRef.removeAllObservers()
    }
    
}
