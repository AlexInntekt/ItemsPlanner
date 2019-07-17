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
                    print("Error occured in signing user in. Finding code: fhw0fgiofhojouyy ", error)
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
    
    
    
    @IBOutlet weak var passwordReset: UIButton!
    @IBAction func passwordReset(_ sender: Any)
    {
        
        if ((self.email.text != nil) && (self.email.text != ""))
        {
            let email=self.email.text!
            
            Auth.auth().sendPasswordReset(withEmail: email) { error in
                if let error=error
                {
                    alert(UIVC: self, title: "eroare", message: error as! String)
                    
                }
            } //end Auth.auth()
            
            alert(UIVC: self, title: "Confirmat", message: "Un link de resetare a parolei v-a fost trimis prin email, pe adresa \(email)")
        } //end if
        else
        {
            
            alert(UIVC: self, title: "Câmp gol", message: "Introduceți adresa de email in câmpul de email și apăsați din nou resetare pentru resetarea parolei")
        }
        
       
    }//end passwordReset
    
    
    
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
       
        test_bookings()
       
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
    
    
    func test_items()
    {
        var fitems = [Item]()
        
        fetchItemsByCategory(category: "C1",completion: { (items) -> Void in
            
            fitems=items
            
            for obj in fitems
            {
                print(obj.description)
                
            }
//            print("nr", fitems.count)
//            print("finished running fetchAllItems")
        })
    }
    
    func test_bookings()
    {
//        let ref = Database.database().reference(withPath: "items-planner")
//
//
//        ref.child("Items").observeSingleEvent(of: .value, with: { (snapshot) in
//            // Get user value
//            let value = snapshot.value as? NSDictionary
//
//            print(value)
//
//            // ...
//        }) { (error) in
//            print(error.localizedDescription)
//        }
//        //elem.setValue("12-26 August")
        
//        Database.database().reference(withPath: "Bookings").observe(DataEventType.childAdded, with:
//            {(snap) in print()
//                let a = snap.childSnapshot(forPath: "descriere").value as! String
//                print(a)
//                print("inqgiowpagn")
//        })
        
        
        //Database.database().reference(withPath: "items-planner").child("bugubugu").setValue("heei")
        
        var fbookings = [Booking]()

        fetchBookings(completion: { (bookings) -> Void in

            fbookings=bookings
            
            for obj in fbookings
            {
                print(obj.description)
            }

        })

    
        
    }
    
  
    //dissmis the keyboard after tapping on 'return' from the textField:
    func textFieldShouldReturn(_ titleTextfield: UITextField) -> Bool
    {
        self.view.endEditing(true)
        return true
    }
    
}

