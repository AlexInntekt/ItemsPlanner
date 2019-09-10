//
//  ModifyItemVC.swift
//  play
//
//  Created by Alexandru-Mihai Manolescu on 10/09/2019.
//  Copyright © 2019 Alexandru-Mihai Manolescu. All rights reserved.
//
//ModifyItemVC

import Foundation
import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class ModifyItemAdminVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextViewDelegate, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "GoToImageVC", sender: indexPath.row)
    }
    
    var images=[UIImage]()
    var displayingCategories:[(key: String, name: String)] = []
    var selectedCategory=(key:"", name:"")
    var indexOfSelectedCategory=0
    var reference = Database.database().reference()
    var currentItem = Item()
    var initialItem = Item()
    
    @IBOutlet weak var backButtonToFirstTextfieldConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var gallery: UICollectionView!
    
    
    @IBOutlet weak var itemNameLabel: UITextField!
    
    @IBOutlet weak var categoryPicker: UIPickerView!
    
    @IBOutlet weak var quantityTextfield: UITextField!
    
    @IBOutlet weak var textView: UITextView!
    
    var imagePicker = UIImagePickerController()
    
    var ref = Database.database().reference()
    
    @IBAction func addImage(_ sender: Any)
    {
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        let imagesFolder = Storage.storage().reference().child("images")
        let image_id="\(NSUUID().uuidString).jpg"
        
        //let image = info[UIImagePickerController.image] as! UIImage
        guard let image = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        let ImageData =  image.jpegData(compressionQuality: 0.5)!
        
        let refStorage = imagesFolder.child(image_id)

        refStorage.putData(ImageData, metadata: nil, completion: { (metadata, error) in
            if error != nil
            {
                print("\n\n! Error code f304hg93hg9 \n\n")
                
            }
            else
            {
                
                refStorage.downloadURL { url, error in
                    if(error==nil)
                    {
                        let itsUrl = url!.absoluteString
                        
                        let path=self.reference.child("Categories").child(self.initialItem.category_id).child("items").child(self.initialItem.id).child("images")
                        let autoid=path.childByAutoId()
                        path.child(autoid.key as! String).child("url").setValue(itsUrl)
                        path.child(autoid.key as! String).child("uid").setValue(image_id)
                        
                        let fbimage = FBImage()
                            fbimage.url = itsUrl
                            fbimage.uid = image_id
                
                        self.currentItem.images.append(fbimage)
                        self.gallery.reloadData()
                        
                    }
                    else
                    {
                        alert(UIVC: self, title: "Eroare", message: "\(error)")
                    }
                    
                }
            }
        })
        
        cauchedImagesToCreate=images
        
        dismiss(animated: true) {

        }
        
        
    }
    
    @IBOutlet weak var saveItem: UIButton!
    @IBAction func saveItem(_ sender: Any)
    {
        
        if(self.quantityTextfield.text?.isInt ?? false)
        {
            let item = Item()
            item.category_name = selectedCategory.name
            item.category_id = selectedCategory.key
            item.description = self.textView?.text ?? "articol"
            item.name = self.itemNameLabel?.text ?? "descriere articol"
            item.quantity = Int(self.quantityTextfield.text!) ?? 1
            item.id = currentItem.id
            
            if(isDeviceOnline)
            {
                self.updateItemInDB(item: item)
            }
            else
            {
                alert(UIVC: self, title: "Eroare de conexiune", message: "Conexiunea la internet este slabă sau inexistentă. Reîncercați.")
            }

        }
        else
        {
            alert(UIVC: self, title: "Invalid", message: "Introduceți un număr întreg in câmpul de cantități.")
        }
        
    }
    
    
    func updateItemInDB(item item: Item)
    {
        
        self.saveItem.isEnabled=false
        
        let db = reference.child("Categories").child(selectedCategory.key).child("items")
        let id = item.id
        let dict = ["name": item.name,"descriere": item.description,"cantitate": item.quantity] as [String : Any]
        
        let pathToInitialItem = reference.child("Categories").child(initialItem.category_id).child("items").child(self.currentItem.id)

        
        db.child(id).updateChildValues(dict) { (error, reference) in
            if(error==nil)
            {
                //if the category is changed, then we have to remove the old item because a new one was added under another category parent:
                if(self.initialItem.category_id != self.selectedCategory.key)
                {
                    pathToInitialItem.child("images").observeSingleEvent(of: .value, with: { (snapshot) in
                        db.child(id).updateChildValues(["images":snapshot.value]) //move images info block too
                        pathToInitialItem.removeValue()
                    })
                    
                    
                }
                

                let title = "Modificare cu succes"
                let message = "Obiectul a fost modificat în baza de date!"
                let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { _ in
                    self.performSegue(withIdentifier: "back", sender: nil)
                }))
                
                self.present(alert, animated: true)
            }
            else
            {
                self.saveItem.isEnabled=true
                
                alert(UIVC: self, title: "Eroare detectată", message: "Articolul nu a putut fi adăugat. Dacă problema persistă, contactați dezvoltatorii. Eroare:  \(error.debugDescription)")
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        print("calling viewWillAppear")
        setupui()

        loadCategoriesFromDB()

        self.gallery.reloadData()
        
        //ref = Database.database().reference().child("Categories").child(initialItem.category_id).child("items").child(initialItem.id).child("images")
        
    }
    
    
    override func viewDidLoad()
    {
        self.textView.delegate = self
        self.itemNameLabel.delegate = self
        self.categoryPicker.delegate = self
        self.categoryPicker.dataSource = self
        self.imagePicker.delegate = self

    }
    
    func loadCategoriesFromDB()
    {
        displayingCategories.removeAll()
        
        
        
        reference.child("Categories").observeSingleEvent(of: .value) { (allCategories) in
            
            for category in allCategories.children.allObjects as! [DataSnapshot]{
                let category_name = category.childSnapshot(forPath: "name").value as! String
                self.displayingCategories.append((key:category.key,name:category_name))
                
                //print(category.key)
            }
            
            
            self.categoryPicker.reloadAllComponents()
            
            if(!self.displayingCategories.isEmpty)
            {
                self.selectedCategory=self.displayingCategories[0]
            }
            
            

            var index=0
            for section in self.displayingCategories
            {
                
                if(section.name==self.currentItem.category_name)
                {
                    self.categoryPicker.selectRow(index, inComponent: 0, animated: false)
                    self.selectedCategory=self.displayingCategories[index]
                }
                index+=1
                
            }
            
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
        return displayingCategories[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if(!displayingCategories.isEmpty)
        {
            self.selectedCategory=displayingCategories[row]
            self.indexOfSelectedCategory=row
        }
        
        
    }
    
    /* Updated for Swift 4 */
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    /* Older versions of Swift */
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
        
        self.itemNameLabel.text = currentItem.name
        self.textView.text = currentItem.description
        self.quantityTextfield.text = String(self.currentItem.quantity)

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
            currentItem.name=self.itemNameLabel.text ?? ""
            currentItem.description=self.textView.text ?? ""
            currentItem.category_id=selectedCategory.key
            
            let obj = sender as! Int
            let defVC = segue.destination as! ImageVC2
            defVC.imageIndex = obj
            defVC.currentItem = currentItem
            defVC.initialItem = initialItem
            let cell = gallery.cellForItem(at: IndexPath(row: obj, section: 0)) as! ImageCell
            defVC.uiimage = cell.image.image!
            
        }
    }
    
    
    
    
}
