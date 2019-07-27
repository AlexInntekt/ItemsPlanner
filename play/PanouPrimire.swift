//
//  PanouPrimire.swift
//  
//
//  Created by Alexandru-Mihai Manolescu on 14/07/2019.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class PanouPrimire: UIViewController
{
    
    @IBOutlet weak var welcomeLabel: UILabel!
    
    @IBOutlet weak var logout: UIButton!
    @IBAction func logout(_ sender: Any)
    {
        do{
            try Auth.auth().signOut()
        } catch{
            
        }
        
        performSegue(withIdentifier: "logoutSegue", sender: nil)
    }
    
    func showSimpleAlert(message: String) {
        let alert = UIAlertController(title: "Signing in problem", message: message, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { _ in
            //Cancel Action
        }))
        
        self.present(alert, animated: true, completion: nil)
    }

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        
        print("PanouPrimire este in deschis")
        
        setupUI()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if Auth.auth().currentUser != nil {
            welcomeLabel.text="Bine ai venit, \(Auth.auth().currentUser!.displayName!)"
            //showSimpleAlert(message: "user")
            //showSimpleAlert(message: Auth.auth().currentUser!.displayName!)
        } else {
            showSimpleAlert(message: "error")
        }
        
        test_fetch_all_items()
    }
    
    func setupUI()
    {
        
    }
}
