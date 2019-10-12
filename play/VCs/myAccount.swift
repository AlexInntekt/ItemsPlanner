//
//  myAccount.swift
//  FirebaseAuth
//
//  Created by Alexandru-Mihai Manolescu on 13/09/2019.
//

import Foundation
import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth


class MyAccount: UIViewController
{
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBAction func save(_ sender: Any)
    {
        let thisUser = Auth.auth().currentUser!
        
        if(isDeviceOnline)
        {
            if(emailTextField.text != nil)
            {
                let newEmail = emailTextField.text!
                thisUser.updateEmail(to: newEmail)
                reference.child("Users").child(thisUser.uid).child("email").setValue(newEmail)
            }
            if(phoneTextField.text != nil)
            {
                let newPhone = phoneTextField.text!
                reference.child("Users").child(thisUser.uid).child("phoneNumber").setValue(newPhone)
            }
            if(usernameTextField.text != nil)
            {
                let newUserName = usernameTextField.text!
                reference.child("Users").child(thisUser.uid).child("name").setValue(newUserName)
                GlobalCurrentUserName = newUserName
            }
            
            alert(UIVC: self, title: "Succes", message: "Schimbările au fost trimise catre server!")
        }
        else
        {
            alert(UIVC: self, title: "Conexiune slabă", message: "Conexiunea de internet pare a fi slabă. Încercați din nou.")
        }
        
    }
    override func viewDidLoad()
    {
        
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        
        if(!isDeviceOnline)
        {
            alert(UIVC: self, title: "Conexiune slabă", message: "Conexiunea de internet pare a fi slabă. Încercați din nou.")
        }
        
        let path = reference.child("Users").child(Auth.auth().currentUser!.uid)
        
        path.observeSingleEvent(of: .value) { (pack) in
            
            var email = ""
            var phone = ""
            var username = ""
            
            if(pack.hasChild("email"))
            {
                email = pack.childSnapshot(forPath: "email").value as! String
            }
            if(pack.hasChild("phoneNumber"))
            {
                phone = pack.childSnapshot(forPath: "phoneNumber").value as! String
            }
            if(pack.hasChild("name"))
            {
                username = pack.childSnapshot(forPath: "name").value as! String
            }
            
            
            self.emailTextField.text! = email
            self.phoneTextField.text! = phone
            self.usernameTextField.text! = username
        }
        
        
    }
    
}
