//
//  utils.swift
//  play
//
//  Created by Alexandru-Mihai Manolescu on 15/07/2019.
//  Copyright © 2019 Alexandru-Mihai Manolescu. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth

func alert(UIVC: UIViewController ,title: String, message: String)
{
    let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { _ in
        
    }))
    UIVC.present(alert, animated: true)
}




func isUserLoggedIn() -> Bool
{
    var cond = false
    
    if Auth.auth().currentUser != nil {
        cond = true
        print("\n\n STATUS The user is logged in \n")
    } else {
        print("\n\n STATUS The user is NOT logged in \n")
        cond = false
    }
    
    return cond
}




func convertEnDateToRo(_ date: String) -> String
{ //"yyyy MM dd"
    let year = "\(date[0])\(date[1])\(date[2])\(date[3])"
    let month = "\(date[5])\(date[6])"
    let day = "\(date[8])\(date[9])"
    
    return "\(day) \(month) \(year)"
}


extension String {
    subscript (i: Int) -> Character {
        return self[index(startIndex, offsetBy: i)]
    }
    subscript (bounds: CountableRange<Int>) -> Substring {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return self[start ..< end]
    }
    subscript (bounds: CountableClosedRange<Int>) -> Substring {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return self[start ... end]
    }
    subscript (bounds: CountablePartialRangeFrom<Int>) -> Substring {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(endIndex, offsetBy: -1)
        return self[start ... end]
    }
    subscript (bounds: PartialRangeThrough<Int>) -> Substring {
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return self[startIndex ... end]
    }
    subscript (bounds: PartialRangeUpTo<Int>) -> Substring {
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return self[startIndex ..< end]
    }
}
extension Substring {
    subscript (i: Int) -> Character {
        return self[index(startIndex, offsetBy: i)]
    }
    subscript (bounds: CountableRange<Int>) -> Substring {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return self[start ..< end]
    }
    subscript (bounds: CountableClosedRange<Int>) -> Substring {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return self[start ... end]
    }
    subscript (bounds: CountablePartialRangeFrom<Int>) -> Substring {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(endIndex, offsetBy: -1)
        return self[start ... end]
    }
    subscript (bounds: PartialRangeThrough<Int>) -> Substring {
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return self[startIndex ... end]
    }
    subscript (bounds: PartialRangeUpTo<Int>) -> Substring {
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return self[startIndex ..< end]
    }
}


func scrollToFirstRow(in tableview: UITableView) {
    let indexPath = NSIndexPath(row: 0, section: 0)
    if(tableview.numberOfRows(inSection: 0)>0)
    {
        tableview.scrollToRow(at: indexPath as IndexPath, at: .top, animated: true)
    }
    
}


struct AppUtility {
    
    static func lockOrientation(_ orientation: UIInterfaceOrientationMask) {
        
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            delegate.orientationLock = orientation
        }
    }
    
    /// OPTIONAL Added method to adjust lock and rotate to the desired orientation
    static func lockOrientation(_ orientation: UIInterfaceOrientationMask, andRotateTo rotateOrientation:UIInterfaceOrientation) {
        
        self.lockOrientation(orientation)
        
        UIDevice.current.setValue(rotateOrientation.rawValue, forKey: "orientation")
        UINavigationController.attemptRotationToDeviceOrientation()
    }
    
}

extension String {
    var isInt: Bool {
        return Int(self) != nil
    }
}

func remove_duplicates_in_bookings_array(_ array: [Booking])->[Booking]
{
    var results = [Booking]()
    
    for bk in array
    {
        var isAlreadyFetched = false
        for r in results
        {
            if(r.id==bk.id)
            {
                isAlreadyFetched=true
            }
        }
        if(!isAlreadyFetched)
        {
            results.append(bk)
        }
    }
    
    return results
}
