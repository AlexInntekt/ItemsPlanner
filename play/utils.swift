//
//  utils.swift
//  play
//
//  Created by Alexandru-Mihai Manolescu on 15/07/2019.
//  Copyright © 2019 Alexandru-Mihai Manolescu. All rights reserved.
//

import Foundation
import UIKit


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
    
    return cond
}
