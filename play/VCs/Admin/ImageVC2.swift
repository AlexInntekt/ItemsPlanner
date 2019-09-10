//
//  ImageVC2.swift
//  play
//
//  Created by Alexandru-Mihai Manolescu on 10/09/2019.
//  Copyright © 2019 Alexandru-Mihai Manolescu. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

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
        let lalert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        lalert.addAction(UIAlertAction(title: "Nu, anulează", style: UIAlertAction.Style.cancel, handler: { _ in
        }))
        lalert.addAction(UIAlertAction(title: "Da, șterge", style: UIAlertAction.Style.destructive, handler: { _ in
            
            let image_id = self.currentItem.images[self.imageIndex].uid
            let image_acces_id = self.currentItem.images[self.imageIndex].accesid
            let path_to_storage = Storage.storage().reference().child("images")
            
            print("image_id ", image_id)
        reference.child("Categories").child(self.currentItem.category_id).child("items").child(self.currentItem.id).child("images").child(image_acces_id).removeValue()
            
        
            path_to_storage.child(image_id).delete(completion: { (error) in

            })
            
            self.currentItem.images.remove(at: self.imageIndex)
            
            self.dismiss(animated: true, completion: nil)
        }))
        
        self.present(lalert, animated: true)
        
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
