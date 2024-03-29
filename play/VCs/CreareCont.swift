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

class CreareCont: UIViewController, UITextFieldDelegate
{
    
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var phoneNumber: UITextField!
    
    var allowedEmails = [String]()
    let path = Database.database().reference().child("UsersEmail")
    
    func startAccountCreationProcess()
    {

        if ((email.text != nil) &&  (password.text != nil) && (username.text != nil))
        {
            self.signup.setTitle("Se procesează..", for: .normal)
            
            Auth.auth().createUser(withEmail: self.email.text!, password: self.password.text!, completion: { (user, error) in
                print("\n\n # Trying to create a new user...\n")
                
                if error != nil
                {
                    print("Error detected. Finding in console: g7i23h49fofou23go ",error)
                    alert(UIVC: self, title: "Eroare", message: "O eroare a intervenit: \(error!.localizedDescription)")
                    self.signup.setTitle("Crează", for: .normal)
                }
                else
                {
                    let user = Auth.auth().currentUser
                    if let user = user {
                        let changeRequest = user.createProfileChangeRequest()
                        
                        changeRequest.displayName = self.username.text!
                        
                        let userId = Auth.auth().currentUser!.uid
                        
                        let ref = Database.database().reference().child("Users")
                        //                        let values = {["name":changeRequest.displayName];["phoneNumber":"xxx-xxx-xxx"]}
                        ref.updateChildValues([userId : ""])
                        let userPath = ref.child(userId)
                        userPath.updateChildValues(["name" : changeRequest.displayName])
                        userPath.updateChildValues(["phoneNumber" : self.phoneNumber.text])
                        
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
    
    func isEmailAllowed(email email: String)->Bool
    {
        var isAllowed = false
        
        for str in allowedEmails
        {
            print(str)
            if(str.lowercased()==email.lowercased())
            {
                isAllowed=true
            }
        }
        
        return isAllowed
    }
    
    @IBOutlet weak var signup: UIButton!
    @IBAction func signup(_ sender: Any)
    {
        if(isDeviceOnline)
        {
            if((email.text == nil || email.text!.isEmpty) ||
               (password.text == nil || password.text!.isEmpty) ||
               (username.text == nil || username.text!.isEmpty))
            {
                alert(UIVC: self, title: "Invalid", message: "Câmpuri goale.")
            }
            else
            {
                if(isEmailAllowed(email: email.text!.lowercased()))
                {
                    startAccountCreationProcess()
                }
                else
                {
                    alert(UIVC: self, title: "Permisiune respinsă", message: "Adresa de email nu a fost aprobată de către administrator.")
                }
                
            }
            
            
        }
        else
        {
            alert(UIVC: self, title: "Eroare", message: "Conexiunea de internet este slabă sau inexistentă.")
        }
    }
    
    
    func send_verification_email()
    {
        
        Auth.auth().currentUser?.sendEmailVerification { (error) in
            if error != nil
            {
                print("Error in sending verification email. Finding code: w8hgf0qhg02h3g ", error)
                
                alert(UIVC: self, title: "eroare", message: error as! String)
            }
            else
            {
                self.alert_confirmation(UIVC: self, title: "Urmatorul pas", message: "Un email de verificare a fost trimis pentru validarea contului. Urmariti link-ul pentru finalizare")
            }
            
        }
    }
    
    
    
    
    func alert_confirmation(UIVC: UIViewController ,title: String, message: String)
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { _ in
            self.performSegue(withIdentifier: "homeSegue", sender: nil)
        }))
        UIVC.present(alert, animated: true)
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
        
        self.email.delegate = self
        self.password.delegate = self
        self.username.delegate = self
        self.phoneNumber.delegate = self
        setupUI()
    }
    
    //dissmis the keyboard after tapping on 'return' from the textField:
    func textFieldShouldReturn(_ titleTextfield: UITextField) -> Bool
    {
        self.view.endEditing(true)
        return true
    }
    
    func loadDataFromDB()
    {

        path.observe(.value) { (list) in
            self.allowedEmails.removeAll()
            for snap in list.children.allObjects as! [DataSnapshot]
            {
                let femail = snap.value as! String
                
                self.allowedEmails.append(femail)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        loadDataFromDB()
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        path.removeAllObservers()
    }
    
    
}
