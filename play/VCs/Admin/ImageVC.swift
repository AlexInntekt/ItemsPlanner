//
//  ImageVC.swift
//  play
//
//  Created by Alexandru-Mihai Manolescu on 13/08/2019.
//  Copyright © 2019 Alexandru-Mihai Manolescu. All rights reserved.
//

import Foundation
import UIKit

class ImageVC: UIViewController
{
    @IBOutlet weak var currentImage: UIImageView!
    
    var image = UIImage()
    
    @IBAction func backButton(_ sender: Any) {
        self.performSegue(withIdentifier: "back", sender: nil)
    }
    
    override func viewDidLoad()
    {
        self.currentImage.image=image
    }
    
    
}
