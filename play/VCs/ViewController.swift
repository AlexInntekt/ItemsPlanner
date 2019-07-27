//
//  ViewController.swift
//  play
//
//  Created by Alexandru-Mihai Manolescu on 12/07/2019.
//  Copyright © 2019 Alexandru-Mihai Manolescu. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth




class ViewController: UIViewController, UITextFieldDelegate{
 
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var login: UIButton!
    @IBAction func login(_ sender: Any)
    {
        
        if(email.text != nil && password.text != nil)
        {
            
            Auth.auth().signIn(withEmail: email.text!, password: password.text!) { (user, error) in
                
                print("\n\n # Trying to sign in...\n")
                if error != nil
                {
                    self.loginFeedback(error: (error?.localizedDescription)!)
                }
                else if let user=Auth.auth().currentUser
                {
                    if(!user.isEmailVerified)
                    {
                        let unverified = UIAlertController(title: "Contul nu este validat", message: "Contul este creat, dar nu a fost verificat folosind emailul primit!", preferredStyle: UIAlertController.Style.alert)
                        unverified.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { _ in
                            //Cancel Action
                        }))
                        self.present(unverified, animated: true, completion: nil)
                    }
                    else
                    {
                        self.performSegue(withIdentifier: "loginSegue", sender: nil)
                    }
                }
    
                
            }
            
            
            
        }
        
    }
    
    func loginFeedback(error error: String)
    {
        print("Error occured in signing user in. Finding code: fhw0fgiofhojouyy ", error)
        
        var error_message=""
        
        switch error {
            case "The password is invalid or the user does not have a password.":
                error_message="Parola este greșită sau utilizatorul nu există"
            case "The email address is badly formatted.": error_message="Adresa de email este greșită sau nu există."
            default:error_message="S-a produs o eroare"
        }
        
        alert(UIVC: self, title: "Logare nereușită", message: error_message)
    }
    
    
    @IBOutlet weak var passwordReset: UIButton!
    
    
    
    
    @IBOutlet weak var signup: UIButton!
    @IBAction func signup(_ sender: Any)
    {
        
    }
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        email.delegate = self
        password.delegate = self
        
        setupUI()
       

       
    }

    
    func setupUI()
    {
        self.email.placeholder="email"
        self.password.placeholder="password"
        
        self.signup.layer.cornerRadius=20
        self.signup.layer.borderColor=UIColor.gray.cgColor
        self.signup.layer.borderWidth=1
        
        self.passwordReset.layer.cornerRadius=16
        self.passwordReset.layer.borderColor=UIColor.gray.cgColor
        self.passwordReset.layer.borderWidth=1
        
        self.login.layer.cornerRadius=16
        self.login.layer.borderColor=UIColor.gray.cgColor
        self.login.layer.borderWidth=1

    }
    
    override func viewWillAppear(_ animated: Bool)
    {
       
        
        
        animate_startup()
    }
    
    
    func animate_startup()
    {
        let screenRect = UIScreen.main.bounds
        let screenWidth = screenRect.size.width
        
        var t = CGAffineTransform.identity
        t = t.translatedBy(x: -screenWidth, y: 0)
        self.email.transform=t
        self.password.transform=t
        self.login.alpha=0
        
        
        UIView.animate(withDuration: 0.7, animations: {
            self.email.transform = CGAffineTransform.identity.translatedBy(x: 0, y: 0)
        }, completion: { _ in
            UIView.animate(withDuration: 0.7, animations: {
                self.password.transform = CGAffineTransform.identity.translatedBy(x: 0, y: 0)
            }, completion: { _ in
                UIView.animate(withDuration: 1.2, animations: {self.login.alpha=1})
            })
        })
    }
    
    
   
    
  
    //dissmis the keyboard after tapping on 'return' from the textField:
    func textFieldShouldReturn(_ titleTextfield: UITextField) -> Bool
    {
        self.view.endEditing(true)
        return true
    }
    
}

