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
import JTAppleCalendar


extension PanouPrimire: JTACMonthViewDataSource {
    func configureCalendar(_ calendar: JTACMonthView) ->
        ConfigurationParameters {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy MM dd"
        let startDate = formatter.date(from: "2018 01 01")!
        let endDate = Date()
        return ConfigurationParameters(startDate: startDate, endDate: endDate)
    }
}

extension PanouPrimire: JTACMonthViewDelegate {
    func calendar(_ calendar: JTACMonthView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTACDayCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "DateCell", for: indexPath) as! DateCell
        self.calendar(calendar, willDisplay: cell, forItemAt: date, cellState: cellState, indexPath: indexPath)
        return cell
    }
    
    func calendar(_ calendar: JTACMonthView, willDisplay cell: JTACDayCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        configureCell(view: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTACMonthView, headerViewForDateRange range: (start: Date, end: Date), at indexPath: IndexPath) -> JTACMonthReusableView {
        let formatter = DateFormatter()  // Declare this outside, to avoid instancing this heavy class multiple times.
        formatter.dateFormat = "MMM"
        
        let header = calendar.dequeueReusableJTAppleSupplementaryView(withReuseIdentifier: "DateHeader", for: indexPath) as! DateHeader
        header.monthTitle.text = formatter.string(from: range.start)
        return header
    }
    
    func calendarSizeForMonths(_ calendar: JTACMonthView?) -> MonthSize? {
        return MonthSize(defaultSize: 50)
    }
    
    
}

class PanouPrimire: UIViewController
{
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
            cell.selectedView.layer.cornerRadius =  13
            cell.selectedView.isHidden = false
        } else {
            cell.selectedView.isHidden = true
        }
    }
    
//    public func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int
//    {
//        return 5
//    }
    
    
//    @IBOutlet var calendarView: JTACMonthView!
    
    @IBOutlet var calendarView: JTACMonthView!
    
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

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
//        calendarView.ibCalendarDataSource = self
//        calendarView.ibCalendarDelegate = self
        
        print("PanouPrimire este in deschis")
        
        self.calendarView.scrollingMode = .stopAtEachCalendarFrame
        
        setupUI()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if Auth.auth().currentUser != nil {
            welcomeLabel.text="Bine ai venit, \(Auth.auth().currentUser!.displayName!)"
            //showSimpleAlert(message: "user")
            //showSimpleAlert(message: Auth.auth().currentUser!.displayName!)
        } else {
            showSimpleAlert(message: "error")
        }
    }
    
    func setupUI()
    {
        
    }
}
