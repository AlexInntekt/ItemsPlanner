//
//  AddItemAdminVC.swift
//  play
//
//  Created by Alexandru-Mihai Manolescu on 10/08/2019.
//  Copyright © 2019 Alexandru-Mihai Manolescu. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class AddItemAdminVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextViewDelegate, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = gallery.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as? ImageCell
        cell!.image.image = images[indexPath.row]
        
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "GoToImageVC", sender: images[indexPath.row])
    }
    
    var images=[UIImage]()
    var displayingCategories=[String]()
    var selectedCategory=""
    var indexOfSelectedCategory=0
    let reference = Database.database().reference()
    var cachingItem = Item()
    var cachedItem = Item()

    
    @IBOutlet weak var backButtonToFirstTextfieldConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var gallery: UICollectionView!
    
    
    @IBOutlet weak var itemNameLabel: UITextField!
    
    @IBOutlet weak var categoryPicker: UIPickerView!
    
    @IBOutlet weak var textView: UITextView!
    
    var imagePicker = UIImagePickerController()
    
    
    @IBAction func addImage(_ sender: Any)
    {
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        //let image = info[UIImagePickerController.image] as! UIImage
        guard let image = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        images.append(image)
        
        cauchedImagesToCreate=images
        
        dismiss(animated: true) {
            self.gallery.reloadData()
            self.showOrHideGallery()
        }
        
        
    }
    
    @IBOutlet weak var saveItem: UIButton!
    @IBAction func saveItem(_ sender: Any)
    {

        let item = Item()
            item.category = selectedCategory
            item.description = self.textView?.text ?? "articol"
            item.name = self.itemNameLabel?.text ?? "descriere articol"
        //createItem(item: item, byCategory: selectedCategory)
        
        
//        let ImadeData = UIImageJPEGRepresentation(imageContainer.image!, 0.5)!
        //let imageInstance = UIImage
        
        self.saveItemInDB(item: item)

        
    }
    
    func saveItemInDB(item item: Item)
    {
        let db = reference.child("Categories").child(selectedCategory).child("items")
        db.childByAutoId()
        let id = db.childByAutoId().key as! String
        let dict = ["name": item.name,"descriere": item.description]
        
        let imagesFolder = Storage.storage().reference().child("images")
        
        db.child(id).setValue(dict) { (error, reference) in
            if(error==nil)
            {
                
                for image in self.images
                {
                    let image_id="\(NSUUID().uuidString).jpg"
                    let ImageData =  image.jpegData(compressionQuality: 0.5)!
                    
                    let refStorage = imagesFolder.child(image_id)
                    refStorage.putData(ImageData, metadata: nil, completion: { (metadata, error) in
                        if error != nil
                        {
                            print("\n\n! Error code f304hg93hg9 \n\n")
                            
                        }
                        else
                        {
                            print("\n\n#Succesfully uploaded the image on Firebase.\n")
                            
                            print("woihgowhgwtwowphgw")
                            
                            refStorage.downloadURL { url, error in
                                let itsUrl = url!.absoluteString
                                
                                let path=self.reference.child("Categories").child(item.category).child("items").child(id).child("images")
                                let autoid=path.childByAutoId()
                                path.child(autoid.key as! String).child("url").setValue(itsUrl)
                                path.child(autoid.key as! String).child("uid").setValue(image_id)
                                
//                                let pathToImageUrl=self.reference.child("Categories").child(item.category).child("items").child(id).child("image_url")
//                                let pathToImageUid=self.reference.child("Categories").child(item.category).child("items").child(id).child("image_uids")
//                                let autoid=pathToImageUrl.childByAutoId()
////                                print("autoid: ", autoid)
//                                pathToImageUrl.child(autoid.key as! String).setValue(itsUrl)
//
//                                let autoidForUid=pathToImageUid.childByAutoId()
//                                pathToImageUid.child(autoidForUid.key as! String).setValue(image_id)
                                
                            }
                        }
                    })
                }
                
                showCachedItem=false
                
                let title = "Adăugare cu succes"
                let message = "Obiectul a fost adaugat in baza de date!"
                let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { _ in
                    self.performSegue(withIdentifier: "backToItemsSegue", sender: nil)
                }))
                
                self.present(alert, animated: true)
            }
            else
            {
                alert(UIVC: self, title: "Eroare detectată", message: "Articolul nu a putut fi adăugat. Dacă problema persistă, contactați dezvoltatorii. Eroare:  \(error.debugDescription)")
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        setupui()
    }
    
    override func viewDidLoad()
    {
        self.textView.delegate = self
        self.itemNameLabel.delegate = self
        self.categoryPicker.delegate = self
        self.categoryPicker.dataSource = self
        self.imagePicker.delegate = self
        
        dealWithCachedItem()
        loadCategoriesFromDB()
    }
    
    func loadCategoriesFromDB()
    {
        displayingCategories.removeAll()
        
        
        
        reference.child("Categories").observeSingleEvent(of: .value) { (allCategories) in
            
            for category in allCategories.children.allObjects as! [DataSnapshot]{
                self.displayingCategories.append(category.key)
                
                print(category.key)
            }

            self.categoryPicker.reloadAllComponents()
            
            self.selectedCategory=self.displayingCategories[0]
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 40
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return displayingCategories.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return displayingCategories[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if(!displayingCategories.isEmpty)
        {
            self.selectedCategory=displayingCategories[row]
            self.indexOfSelectedCategory=row
        }
        
        
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    //dissmis the keyboard after tapping on 'return' from the textField:
    func textFieldShouldReturn(_ titleTextfield: UITextField) -> Bool
    {
        self.view.endEditing(true)
        return true
    }
    
    func setupui()
    {
        dealWithCachedItem()
        showOrHideGallery()
    }
    
    func dealWithCachedItem()
    {

        if(showCachedItem)
        {
            self.itemNameLabel.text = cachedItem.name
            self.textView.text = cachedItem.description
            self.images = cauchedImagesToCreate
            
            print("showCachedItem true")
        }
        else
        {
            print("showCachedItem false")
        }

        
        
    
    }
    
    func showOrHideGallery()
    {
        if(gallery.numberOfItems(inSection: 0)==0)
        {
            backButtonToFirstTextfieldConstraint.constant=20
        }
        else
        {
            backButtonToFirstTextfieldConstraint.constant=140
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier=="GoToImageVC")
        {
            cachingItem.name=self.itemNameLabel.text ?? ""
            cachingItem.description=self.textView.text ?? ""
            
            
            let obj = sender as! UIImage
            let defVC = segue.destination as! ImageVC
            defVC.image = obj
            defVC.images = self.images
            defVC.currentItem = cachingItem
            
            showCachedItem=true
        }
    }
    

    
    
}
