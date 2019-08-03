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

let formatter = DateFormatter()  // Declare this outside, to avoid instancing this heavy class multiple times.
let date=Date()


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

class BookItemVC: UIViewController, UITextFieldDelegate, UITextViewDelegate
{
    var currentItem=Item()
    var startDateOfBooking=""
    var endDateOfBooking=""
    
    @IBOutlet weak var calendarView: JTACMonthView!
 
    @IBOutlet var numeArticol: UILabel!
    
    @IBOutlet var textfieldDescription: UITextView!
    
    @IBOutlet var bookButton: UIButton!
    @IBAction func bookButton(_ sender: Any)
    {
        
        let dif = DateIntervalFormatter()
        formatter.dateFormat = "YYYY MM dd"
        let date1 = formatter.date(from: startDateOfBooking)!
        let date2 = formatter.date(from: endDateOfBooking)!
        let current_user_id = Auth.auth().currentUser?.uid
        
        let chosenInterval = DateInterval(start: date1, end: date2)
        
        
        
        let ref = Database.database().reference().child("Categories").child(currentItem.category).child("items").child(currentItem.id)
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            
            if snapshot.hasChild("bookings"){
                
                fetchAllBookingsByItemID(item: self.currentItem.id, category: self.currentItem.category, completion: { (bookings) -> Void in
                    
                            var userThatBooked=""
                            var usersPhoneNumebrThatBooked=""
                
                            var isAvailable = true
                
                            for obj in bookings
                            {
                                let date3 = formatter.date(from: obj.startDate)!
                                let date4 = formatter.date(from: obj.endDate)!
                
                                let currentInterval = DateInterval(start: date3, end: date4)
                
                                let res = chosenInterval.intersects(currentInterval)
                
                                if(res==true)
                                {
                                    isAvailable=false
                                    
                                    userThatBooked=obj.user
                                }
                            }
                
                            if(isAvailable)
                            {
                                addBooking(itemName: self.currentItem.name, item: self.currentItem.id, of_user_id: current_user_id!, description: self.textfieldDescription.text, in_category: self.currentItem.category, startdate: self.startDateOfBooking, enddate: self.endDateOfBooking)
                
                                
                                let title = "Rezervare efectuată"
                                let message = "Rezervarea a fost facută cu succes!"
                                let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
                                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { _ in
                                    self.dismiss(animated: true, completion: nil)
                                    print("Dismissing VC after adding booking")
                                }))
                                self.present(alert, animated: true)
                                
                                
                            }
                            else
                            {
                                alert(UIVC: self, title: "Rezervare eșuată", message: "Rezervarea nu a putut fi efectuată deoarece există deja o rezervare in această perioada pentru articolul selectat. \n Utilizator: \(userThatBooked)")
                            }
                
                        })
                
            }else{
                
                addBooking(itemName: self.currentItem.name, item: self.currentItem.id, of_user_id: current_user_id!, description: self.textfieldDescription.text, in_category: self.currentItem.category, startdate: self.startDateOfBooking, enddate: self.endDateOfBooking)
                
                alert(UIVC: self, title: "Rezervare efectuată", message: "Rezervarea a fost facută cu succes!")
            }
            
            
        })
        
//        fetchAllBookingsByItemID(item: currentItem.id, category: currentItem.category, completion: { (bookings) -> Void in
//
//
//            var isAvailable = true
//
//            for obj in bookings
//            {
//                let date3 = formatter.date(from: obj.startDate)!
//                let date4 = formatter.date(from: obj.endDate)!
//
//                let currentInterval = DateInterval(start: date3, end: date4)
//
//                let res = chosenInterval.intersects(currentInterval)
//
//                if(res==false)
//                {
//                    isAvailable=res
//                }
//            }
//
//            if(isAvailable)
//            {
//                addBooking(item: self.currentItem.id, of_user: "Alex", description: self.textfieldDescription.text, in_category: self.currentItem.category, startdate: self.startDateOfBooking, enddate: self.endDateOfBooking)
//
//                alert(UIVC: self, title: "Rezervare efectuată", message: "Rezervarea a fost facută cu succes!")
//            }
//            else
//            {
//                alert(UIVC: self, title: "Rezervare eșuată", message: "Rezervarea nu a putut fi efectuată deoarece există deja o rezervare in această perioada pentru articolul selectat.")
//            }
//
//        })
        
    }
    
    
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
                
                print(date_as_string)
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
        
        print("Current selected item: \(self.currentItem.name)")
        print("category: \(self.currentItem.category)")
        print("id: \(self.currentItem.id)")
    }
    
    func setupUI()
    {
        self.textfieldDescription.text = "Utilizatorul \(Auth.auth().currentUser!.displayName!) necesită articolul \(currentItem.name) în această perioadă pentru realizarea unui eveniment. Apasă pentru a edita aceasă descriere."
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
    
}
