//
//  BookItemVC.swift
//  play
//
//  Created by Alexandru-Mihai Manolescu on 28/07/2019.
//  Copyright © 2019 Alexandru-Mihai Manolescu. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth
import JTAppleCalendar
import SDWebImage


var reports=[FailedBookingReportModel]()
var useridstofetch=[String]()

extension BookItemVC: JTACMonthViewDataSource {
    func configureCalendar(_ calendar: JTACMonthView) ->
        ConfigurationParameters {
            formatter.dateFormat = "yyyy"
            let currentYear = String(Int(formatter.string(from: date))!+2)
            let startDate = Date()
            
            formatter.dateFormat = "yyyy MM dd"
            let endDate = formatter.date(from: "\(currentYear) 12 31")!
            
            return ConfigurationParameters(startDate: startDate, endDate: endDate)
    }
}

extension BookItemVC: JTACMonthViewDelegate {
    func calendar(_ calendar: JTACMonthView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTACDayCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "DateCell", for: indexPath) as! DateCell
        self.calendar(calendar, willDisplay: cell, forItemAt: date, cellState: cellState, indexPath: indexPath)
        return cell
    }
    
    func calendar(_ calendar: JTACMonthView, willDisplay cell: JTACDayCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        configureCell(view: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTACMonthView, headerViewForDateRange range: (start: Date, end: Date), at indexPath: IndexPath) -> JTACMonthReusableView {
        formatter.dateFormat = "MMM YYYY"
        
        let header = calendar.dequeueReusableJTAppleSupplementaryView(withReuseIdentifier: "DateHeader", for: indexPath) as! DateHeader
        
        header.monthTitle.text = formatter.string(from: range.start)
        
        return header
    }
    
    func calendarSizeForMonths(_ calendar: JTACMonthView?) -> MonthSize? {
        return MonthSize(defaultSize: 50)
    }
    
    
}

class BookItemVC: UIViewController, UITextFieldDelegate, UITextViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currentItem.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = gallery.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as? ImageCell
        
        let url = URL(string: currentItem.images[indexPath.row].url)
        cell!.image.sd_setImage(with: url, completed: nil)
        
        
        //self.imageContainer.sd_setImage(with: url, completed: nil)
        
        return cell!
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "gallerySegue", sender: indexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let height = gallery.frame.size.height
        let width = gallery.frame.size.width
        
        return CGSize(width: width, height: height)
    }
    
    var currentItem=Item()
    var bookingsOfCurrentItem=[Booking]()
    var descriptionOfBooking = ""
    var startDateOfBooking=""
    var endDateOfBooking=""
    
    @IBOutlet weak var gallery: UICollectionView!
    
    @IBOutlet weak var calendarView: JTACMonthView!
 
    @IBOutlet var numeArticol: UILabel!
    
    @IBOutlet var textfieldDescription: UITextView!
    
    @IBOutlet var progressLabel: UILabel!
    
    @IBOutlet weak var imageContainer: UIImageView!
    
    @IBOutlet var bookButton: UIButton!
    
    
    func calendar(_ calendar: JTACMonthView, didSelectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) {
        configureCell(view: cell, cellState: cellState)
    }
    
    
    func calendar(_ calendar: JTACMonthView, didDeselectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) {
        configureCell(view: cell, cellState: cellState)
    }
    
    func configureCell(view: JTACDayCell?, cellState: CellState) {
        guard let cell = view as? DateCell  else { return }
        cell.dateLabel.text = cellState.text
        cell.backgroundColor=UIColor(red:0.95, green:0.95, blue:0.96, alpha:1.0)
        cell.layer.borderWidth=1
        cell.layer.borderColor=UIColor(red:0.8, green:0.8, blue:0.8, alpha:1.0).cgColor
        handleCellTextColor(cell: cell, cellState: cellState)
        handleCellSelected(cell: cell, cellState: cellState)
    }
    
    func handleCellTextColor(cell: DateCell, cellState: CellState) {
        if cellState.dateBelongsTo == .thisMonth {
            cell.dateLabel.textColor = UIColor(red:0.35, green:0.35, blue:0.35, alpha:1.0)
            cell.layer.backgroundColor = UIColor(red:0.93, green:0.93, blue:0.93, alpha:1.0).cgColor
        } else {
            cell.dateLabel.textColor = UIColor(red:0.7, green:0.7, blue:0.7, alpha:1.0)
            cell.layer.backgroundColor = UIColor(red:0.97, green:0.97, blue:0.97, alpha:1.0).cgColor
        }
    }
    
    func handleCellSelected(cell: DateCell, cellState: CellState) {
        if cellState.isSelected {
            cell.selectedView.layer.cornerRadius =  0
            cell.selectedView.isHidden = false
            cell.selectedView.layer.backgroundColor = UIColor(red:0.5, green:0.5, blue:0.55, alpha:1.0).cgColor
            cell.dateLabel.textColor = UIColor(red:0.95, green:0.99, blue:1, alpha:1.0)
            
            formatter.dateFormat="YYYY MM dd"
            
            
            print("\n")
            
            for date in self.calendarView.selectedDates
            {
                //                var date = Calendar.current.date(byAdding: .day, value: 1, to: date)
                
                let date_as_string = formatter.string(from: date)
                
                //print(date_as_string)
            }
            
            self.startDateOfBooking = formatter.string(from: self.calendarView.selectedDates.first!)
            self.endDateOfBooking = formatter.string(from: self.calendarView.selectedDates.last!)
            
        } else {
            cell.selectedView.isHidden = true
        }
        
        
    }
    
    //    public func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int
    //    {
    //        return 5
    //    }
    
    
    //    @IBOutlet var calendarView: JTACMonthView!
    

  
    
    func showSimpleAlert(message: String) {
        let alert = UIAlertController(title: "Signing in problem", message: message, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { _ in
            //Cancel Action
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        print("PanouPrimire este in deschis")
        
        self.calendarView.scrollingMode = .stopAtEachCalendarFrame
        
        self.calendarView.allowsMultipleSelection = true
        self.calendarView.allowsRangedSelection = true
        self.gallery.delegate = self
        self.gallery.dataSource = self
        
        textfieldDescription.delegate = self
        
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if Auth.auth().currentUser != nil {
           
            //showSimpleAlert(message: "user")
            //showSimpleAlert(message: Auth.auth().currentUser!.displayName!)
        } else {
            showSimpleAlert(message: "error")
        }
        
        self.numeArticol.text = self.currentItem.name
        
//        print("Current selected item: \(self.currentItem.name)")
//        print("category: \(self.currentItem.category_name)")
//        print("id: \(self.currentItem.id)")
        
        load_bookings_of_item()
    }
    
    func setupUI()
    {
        
        if(self.descriptionOfBooking=="")
        {
            self.textfieldDescription.text = "Utilizatorul \(Auth.auth().currentUser!.displayName!) necesită articolul \(currentItem.name) în această perioadă pentru realizarea unui eveniment. Apasă pentru a edita aceasă descriere."
        }
        else
        {
            self.textfieldDescription.text = self.descriptionOfBooking
        }
        
        
//        let url=URL(string: "https://firebasestorage.googleapis.com/v0/b/items-planner.appspot.com/o/rachel%20sjet.jpg?alt=media&token=daf8ddd4-3125-48bc-bd9a-2829b552fd3c")
        
        
    }
    

    /* Updated for Swift 4 */
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    /* Older versions of Swift */
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: (Any)?)
    {
        self.descriptionOfBooking = self.textfieldDescription.text
        
        if(segue.identifier=="seeFailedBookingReport")
        {
            let defVC = segue.destination as! FailedBookingReport
            defVC.reports = reports
            defVC.desiredItem = currentItem as! Item
            defVC.descriptionOfBooking = self.descriptionOfBooking
        }
        
        if(segue.identifier=="gallerySegue")
        {
            let defVC = segue.destination as! GalleryVC
            defVC.currentItem = self.currentItem
            defVC.descriptionOfBooking = self.descriptionOfBooking
        }
        
        
        
    }
    
    
    
    
    @IBAction func bookButton(_ sender: Any)
    {
        //check if there is at least one selected date in calendar
        if(calendarView.indexPathsForSelectedItems?.count==0)
        {
            alert(UIVC: self, title: "Input invalid!", message: "Selectați minim o dată din calendar.")
        }
        else
        {
            startBookingProcedure()
        }
        
    }
    

    func extractDaysFromInterval(_ startDate: Date, _ endDate: Date)->[Date]
    {
        let calendar = NSCalendar.current
        var dates=[Date]()
        var date = startDate
        while date <= endDate
        {
            //print(DateFormatter.string(from: startDate))
            date = calendar.date(byAdding: .day, value: 1, to: date)!
            //print(date)
            dates.append(date)
        }
        
        return dates
    }
    
    func find_number_of_available_items()
    {
        
    }
    
    func startBookingProcedure()
    {
        let dif = DateIntervalFormatter()
        formatter.dateFormat = "YYYY MM dd"
        let date1 = formatter.date(from: startDateOfBooking)!
        let date2 = formatter.date(from: endDateOfBooking)!
        let current_user_id = Auth.auth().currentUser?.uid
        
        let chosenInterval = DateInterval(start: date1, end: date2)
        extractDaysFromInterval(date1,date2)
        
        print(bookingsOfCurrentItem)
        
    }
    
    func load_bookings_of_item()
    {
        reference.child("Categories").child(currentItem.category_id).child("items").child(currentItem.id).child("bookings").observe(.value) { (bookings_ids) in
            
            self.bookingsOfCurrentItem.removeAll()
            
            print("Running load_bookings_of_item()")
            for bk_id in bookings_ids.children.allObjects as! [DataSnapshot]
            {
                let id_of_booking = bk_id.value as! String
                
                let path = reference.child("Bookings").child(id_of_booking)
                
                path.observeSingleEvent(of: .value) { (bk) in
                    

                    let booking = Booking()
                    booking.category = self.currentItem.category_id
                    booking.id = id_of_booking
                    booking.itemId = self.currentItem.id
                    booking.itemName = self.currentItem.name
                    booking.description = bk.childSnapshot(forPath: "descriere").value as! String
                    booking.startDate = bk.childSnapshot(forPath: "interval").childSnapshot(forPath: "from").value as! String
                    booking.endDate = bk.childSnapshot(forPath: "interval").childSnapshot(forPath: "till").value as! String
                    booking.user = bk.childSnapshot(forPath: "user").value as! String
                
                    self.bookingsOfCurrentItem.append(booking)
                    
                } //end of observeSingleEvent
            }
        
        }
   
    } //end of load_bookings_of_item()
}
