//
//  Bodyguard.swift
//  play
//
//  Created by Alexandru-Mihai Manolescu on 15/09/2019.
//  Copyright © 2019 Alexandru-Mihai Manolescu. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase
import FirebaseAuth

func enableBodyguard(UIVC uivc: UIViewController)
{
    print("Calling enableBodyguard() ")
    var allowedEmails=[String]()
    var path = Database.database().reference().child("UsersEmail")
    
    path.observeSingleEvent(of: .value) { (list) in
        allowedEmails.removeAll()
        for snap in list.children.allObjects as! [DataSnapshot]
        {
            let email = snap.value as! String
            let key = snap.key as! String
            
            allowedEmails.append(email)
        }
        
        var isAllowed = false
        let email = Auth.auth().currentUser!.email!
        for str in allowedEmails
        {
            if(str.lowercased()==email.lowercased())
            {
                isAllowed=true
            }
        }
        if(isAllowed==false)
        {
            print("isAllowed")
            path.removeAllObservers()
            do{
                try Auth.auth().signOut()
                uivc.performSegue(withIdentifier: "logoutSegue", sender: nil)
            } catch{}
            
        }
    }
}
