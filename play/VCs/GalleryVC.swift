//
//  GalleryVC.swift
//  play
//
//  Created by Alexandru-Mihai Manolescu on 15/08/2019.
//  Copyright © 2019 Alexandru-Mihai Manolescu. All rights reserved.
//

import Foundation
import UIKit

class GalleryVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currentItem.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = gallery.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as? ImageCell
        
        let url = URL(string: currentItem.images[indexPath.row].url)
        cell!.image.sd_setImage(with: url, completed: nil)

        return cell!
    }
    
    var currentItem = Item()
    var descriptionOfBooking = ""
    

    @IBOutlet weak var gallery: UICollectionView!
    
    @IBAction func back(_ sender: Any)
    {
        performSegue(withIdentifier: "back", sender: nil)
    }
    
    override func viewDidLoad()
    {
        self.gallery.dataSource = self
        self.gallery.delegate = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if(segue.identifier=="back")
        {
            let defVC = segue.destination as! BookItemVC
            defVC.currentItem = self.currentItem
            defVC.descriptionOfBooking = self.descriptionOfBooking
        }
    }
    
    
}
