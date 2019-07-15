//
//  CreareCont.swift
//
//
//  Created by Alexandru-Mihai Manolescu on 14/07/2019.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class CreareCont: UIViewController
{
    
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var username: UITextField!
    
    @IBOutlet weak var signup: UIButton!
    @IBAction func signup(_ sender: Any)
    {
        self.signup.setTitle("Se procesează..", for: .normal)
        
        if ((email.text != nil) &&  (password.text != nil) && (username.text != nil))
        {
            
            Auth.auth().createUser(withEmail: self.email.text!, password: self.password.text!, completion: { (user, error) in
                print("\n\n # Trying to create a new user...\n")
                
                if error != nil
                {
                    print("Error detected. Finding in console: g7i23h49fofou23go ",error)
                }
                else
                { 
                    let user = Auth.auth().currentUser
                    if let user = user {
                        let changeRequest = user.createProfileChangeRequest()
                        
                        changeRequest.displayName = self.username.text!
                        
                        changeRequest.commitChanges { error in
                            if let error = error {
                                // An error happened.
                            } else {
                                // Profile updated.
                            }
                        }
                    }
                    
                    self.send_verification_email()
                }
                
                
            })
            
            
            
        }
        
        
        
        
    }
    
    
    func send_verification_email()
    {
        self.signup.frame.size.width = 30
        
        Auth.auth().currentUser?.sendEmailVerification { (error) in
            if error != nil
            {
                print("Error in sending verification email. Finding code: w8hgf0qhg02h3g ", error)
            }
            
        }
    }
    
    func setupUI()
    {
        self.signup.layer.borderWidth=1
        self.signup.layer.borderColor=UIColor.gray.cgColor
        self.signup.layer.cornerRadius=17
        //self.signup.frame.size.width=130
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        
        print("CreareCont este deschis")
        
       
        setupUI()
    }
}
