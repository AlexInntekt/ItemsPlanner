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




class ViewController: UIViewController{
 
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var login: UIButton!
    @IBAction func login(_ sender: Any)
    {
        
    }
    
    @IBOutlet weak var signup: UIButton!
    @IBAction func signup(_ sender: Any)
    {
        
    }
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
       
        setupUI()
       
       
    }
    
    func setupUI()
    {
        self.email.placeholder="email"
        self.password.placeholder="password"
        self.signup.layer.cornerRadius=20
        self.signup.layer.borderColor=UIColor.gray.cgColor
        self.signup.layer.borderWidth=1
        
        self.login.layer.cornerRadius=18
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
        
        
        UIView.animate(withDuration: 1, animations: {
            self.email.transform = CGAffineTransform.identity.translatedBy(x: 0, y: 0)
        }, completion: { _ in
            UIView.animate(withDuration: 1, animations: {
                self.password.transform = CGAffineTransform.identity.translatedBy(x: 0, y: 0)
            }, completion: { _ in
                UIView.animate(withDuration: 0.5, animations: {self.login.alpha=1})
            })
        })
    }
    
    func test_api()
    {
        let ref = Database.database().reference(withPath: "items")
        let elem = ref.child("balon_rosu").child("intervals").child("2")
        
        elem.setValue("12-26 August")
        
    }

    
}

