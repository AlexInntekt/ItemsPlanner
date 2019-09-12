//
//  GalleryVC.swift
//  play
//
//  Created by Alexandru-Mihai Manolescu on 15/08/2019.
//  Copyright © 2019 Alexandru-Mihai Manolescu. All rights reserved.
//

import Foundation
import UIKit

extension GalleryVC {
  
    
     func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.landscape
    }
}

class GalleryVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let height = view.frame.size.height
        let width = view.frame.size.width

        return CGSize(width: width, height: height)
    }
    
    var currentItem = Item()
    var descriptionOfBooking = ""
    var editMode = false
    var existingBookingToModify = Booking()
    var cacheBooking = Booking()
    var cache = true


    @IBOutlet weak var gallery: UICollectionView!
    
    
    @IBOutlet weak var backButtonTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var back: UIButton!
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
            defVC.editMode = self.editMode
            defVC.existingBookingToModify = self.existingBookingToModify.copy()
            defVC.cacheBooking = self.cacheBooking.copy()
            defVC.cache = self.cache
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        AppUtility.lockOrientation(.all)
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        AppUtility.lockOrientation(.portrait)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator)
    {
        super.viewWillTransition(to: size, with: coordinator)
        guard let flowLayout = gallery.collectionViewLayout as? UICollectionViewFlowLayout else
        {
            return
        }
        
        if UIDevice.current.orientation.isLandscape
        {
            print("Landscape")
            self.backButtonTopConstraint.constant = -60
            super.viewWillTransition(to: size, with: coordinator)
//            self.view.backgroundColor = UIColor.black
            
        } else
        {
            print("Portrait")
//            self.view.backgroundColor = UIColor.white
            self.backButtonTopConstraint.constant = 5
        }
        
        flowLayout.invalidateLayout()
    }
    
}
