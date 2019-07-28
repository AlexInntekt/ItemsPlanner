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

class BookItemVC: UIViewController
{
    var currentItem=Item()
    var startDateOfBooking=""
    var endDateOfBooking=""
    
    @IBOutlet weak var calendarView: JTACMonthView!
 
    @IBOutlet var numeArticol: UILabel!
    
    @IBOutlet var bookButton: UIButton!
    @IBAction func bookButton(_ sender: Any)
    {
        addBooking(item: currentItem.id, of_user: "Alex", description: currentItem.description, in_category: currentItem.category, startdate: startDateOfBooking, enddate: endDateOfBooking)
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
            cell.dateLabel.textColor = UIColor.black
        } else {
            cell.dateLabel.textColor = UIColor.gray
        }
    }
    
    func handleCellSelected(cell: DateCell, cellState: CellState) {
        if cellState.isSelected {
            cell.selectedView.layer.cornerRadius =  0
            cell.selectedView.isHidden = false
            
            formatter.dateFormat="YYYY MM dd"
            
            
            print("\n")
            
            for date in self.calendarView.selectedDates
            {
                //                var date = Calendar.current.date(byAdding: .day, value: 1, to: date)
                
                var date_as_string = formatter.string(from: date)
                
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
        
        setupUI()
        
        self.calendarView.allowsMultipleSelection = true
        self.calendarView.allowsRangedSelection = true
        
        
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
        
    }
}
