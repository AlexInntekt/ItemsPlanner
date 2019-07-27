//
//  ResetPassword.swift
//  
//
//  Created by Alexandru-Mihai Manolescu on 27/07/2019.
//

import Foundation
import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth


class ResetPassword: UIViewController, UITextFieldDelegate{

    override func viewDidLoad() {
        
    }
    
    @IBOutlet var instructions: UITextView!
    
    @IBOutlet var email: UITextField!
    
    @IBAction func resetPassword(_ sender: Any) {
        
            
        if ((self.email.text != nil) && (self.email.text != ""))
        {
            let email=self.email.text!
            
            Auth.auth().sendPasswordReset(withEmail: email) { error in
                if let error=error
                {
                    alert(UIVC: self, title: "eroare", message: error as! String)
                    
                }
            } //end Auth.auth()
            
//            alert(UIVC: self, title: "Confirmat", message: "Un link de resetare a parolei v-a fost trimis prin email, pe adresa \(email)")
//
            let feedbackAlert = UIAlertController(title: "Confirmat", message: "Un link de resetare a parolei v-a fost trimis prin email, pe adresa \(email)", preferredStyle: UIAlertController.Style.alert)
            feedbackAlert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { _ in
                self.dismiss(animated: true, completion: nil)
            }))
            self.present(feedbackAlert, animated: true)
            
        } //end if
        else
        {
            
            alert(UIVC: self, title: "Câmp gol", message: "Introduceți adresa de email in câmpul de email și apăsați din nou resetare pentru resetarea parolei")
        }
            
            
        
    }//end passwordReset
    
    func setupUI()
    {
//        self.email.placeholder="email"
//
//
//        self.passwordReset.layer.cornerRadius=16
//        self.passwordReset.layer.borderColor=UIColor.gray.cgColor
//        self.passwordReset.layer.borderWidth=1
//
//
    }
    
    //dissmis the keyboard after tapping on 'return' from the textField:
    func textFieldShouldReturn(_ titleTextfield: UITextField) -> Bool
    {
        self.view.endEditing(true)
        return true
    }
}
