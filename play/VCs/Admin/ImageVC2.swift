//
//  ImageVC2.swift
//  play
//
//  Created by Alexandru-Mihai Manolescu on 10/09/2019.
//  Copyright © 2019 Alexandru-Mihai Manolescu. All rights reserved.
//

import Foundation
import UIKit

class ImageVC2: UIViewController
{
    @IBOutlet weak var currentImage: UIImageView!
    
    var imageIndex = 0
    var currentItem = Item()
    var initialItem = Item()
    var uiimage = UIImage()
    
    
    @IBAction func backButton(_ sender: Any) {
        self.performSegue(withIdentifier: "back", sender: nil)
    }
    
    @IBAction func deleteImage(_ sender: Any)
    {
        let title = "Ștergere imagine"
        let message = "Sigur doriți să eliminați imaginea?"
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Nu, anulează", style: UIAlertAction.Style.cancel, handler: { _ in
        }))
        alert.addAction(UIAlertAction(title: "Da, șterge", style: UIAlertAction.Style.destructive, handler: { _ in
            
            self.currentItem.images.remove(at: self.imageIndex)
            self.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true)
        
    }
    override func viewDidLoad()
    {
        self.currentImage.image=uiimage
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier=="back")
        {
            let defVC = segue.destination as! ModifyItemAdminVC
            defVC.currentItem=currentItem
            defVC.initialItem=initialItem
        }
    }
    
    
}
