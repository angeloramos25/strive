//
//  SecondViewController.swift
//  Habits
//
//  Created by Angelo Ramos on 12/6/16.
//  Copyright © 2016 Palmsonntag, Inc. All rights reserved.
//

import UIKit

var wishesArray = [Wish]()

class SecondViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var costField: UITextField!
    @IBOutlet weak var addView: UIView!
    @IBOutlet weak var addPreview: UIImageView!
    @IBOutlet weak var wishesCollView: UICollectionView!
    @IBOutlet weak var addViewCenter: NSLayoutConstraint!
    
    @IBOutlet weak var editButt: UIButton!
    @IBOutlet weak var nameWishLabel: UILabel!
    @IBOutlet weak var dim: UIView!
    @IBOutlet weak var manImage: UIImageView!
    @IBOutlet weak var noWishLabel: UILabel!
    
    @IBOutlet weak var costWishLabel: UILabel!
    @IBOutlet weak var addPicLabel: UILabel!
    
    var imagePath: String!
    var cellSize = CGSize()
    var editMode: Bool = false
    var wishEdit: Bool = false
    var editIndex: Int = 0
    var textFilled: Bool = false
    
    func getDocumentsURL() -> NSURL {
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return documentsURL as NSURL
    }
    
    func fileInDocumentsDirectory(filename: String) -> String {
        
        let fileURL = getDocumentsURL().appendingPathComponent(filename)
        return fileURL!.path
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.addView.alpha = 0
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SecondViewController.dismissKeyboard))
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)

        cellSize = CGSize(width: view.frame.size.width, height: 200)
        
        self.loadWishes()
        self.wishesCollView.reloadData()
        
        self.nameField.delegate = self
        self.costField.delegate = self
        
        self.costField.keyboardType = UIKeyboardType.numberPad
        
        self.addPreview.contentMode = .scaleAspectFit
        
        if wishesArray.count == 0 {
            manImage.alpha = 1
            noWishLabel.alpha = 1
        }
        else {
            manImage.alpha = 0
            noWishLabel.alpha = 0
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.loadWishes()
        for Wish in wishesArray {
            if Wish.completed {
                wishesArray.remove(at: wishesArray.index(of: Wish)!)
            }
        }
        self.wishesCollView.reloadData()
    }
    
    func saveWishes() {
        let defaults = UserDefaults.standard
        
        let data = NSKeyedArchiver.archivedData(withRootObject: wishesArray)
        defaults.set(data, forKey: "savedWishes")
    }
    
    func loadWishes() {
        let defaults = UserDefaults.standard
        
        if let data = defaults.object(forKey: "savedWishes") as? NSData {
            wishesArray = NSKeyedUnarchiver.unarchiveObject(with: data as Data) as! [Wish]
        }
    }

    
    @IBAction func addButtTapped(_ sender: Any) {
        
        addViewCenter.constant = 0
        addViewCenter.constant += view.bounds.height
        addView.alpha = 1
        self.view.layoutIfNeeded()
        
        UIView.animate(withDuration: 0.5, animations: {
            
            self.addViewCenter.constant -= self.view.bounds.height
            self.dim.alpha = 0.6
            self.view.layoutIfNeeded()
            
        })

        
    }
    @IBAction func cancelButtTapped(_ sender: Any) {
        
        self.hideAddView()
        self.clearAddView()
        
    }
    
    func hideAddView() {
        
        UIView.animate(withDuration: 0.5, animations: {
            
            self.addViewCenter.constant += self.view.bounds.height
            self.view.layoutIfNeeded()
            self.addView.alpha = 0
            self.dim.alpha = 0
            
        })
        
        
    }
    
    func clearAddView() {
        self.nameField.text = ""
        self.costField.text = ""
        self.addPreview.image = nil
        self.nameWishLabel.textColor = UIColor.white
        self.costWishLabel.textColor = UIColor.white
        self.addPicLabel.textColor = UIColor.white
        textFilled = false
    }

    
    func checkTextFields(){
        if nameField.text != "" && costField.text != "" && addPreview.image != nil {
            textFilled = true
        }
        else {
            if nameField.text == "" {
            nameWishLabel.textColor = UIColor.red
            }
            if costField.text == "" {
            costWishLabel.textColor = UIColor.red
            }
            if addPreview.image == nil {
            addPicLabel.textColor = UIColor.red
            }
        }
    }

    
    @IBAction func saveButtTapped(_ sender: Any) {
        self.checkTextFields()
        if !wishEdit && textFilled {
        wishesArray.insert(Wish(name: self.nameField.text!, cost: Int(self.costField.text!)!, imagePath: imagePath), at: 0)
        self.hideAddView()
        self.wishesCollView.reloadData()
        self.clearAddView()
        manImage.alpha = 0
        noWishLabel.alpha = 0
        saveWishes()
        }
        else if wishEdit && textFilled {
            let wish = wishesArray[editIndex]
            if wish.name != self.nameField.text! {
                wish.name = self.nameField.text!
            }
            if wish.cost != Int(self.costField.text!) {
                wish.cost = Int(self.costField.text!)!
            }
            if wish.picPath != self.imagePath {
                wish.picPath = self.imagePath
            }
            self.hideAddView()
            self.wishesCollView.reloadData()
            self.clearAddView()
            saveWishes()
            wishEdit = false
        }
        
    }
    
    @IBAction func camButtTapped(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera;
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    @IBAction func librButtTapped(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary;
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        self.dismiss(animated: true, completion: nil)
        
        let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        
        addPreview.contentMode = .scaleAspectFit
        addPreview.image = pickedImage
        let imageName = UUID().uuidString
        self.imagePath = fileInDocumentsDirectory(filename: imageName)
        self.saveImage(image: pickedImage!, path: self.imagePath)
    }
    
    //Document directory
    func saveImage (image: UIImage, path: String ) {
        
        //let pngImageData = UIImagePNGRepresentation(image)
        let jpgImageData = UIImageJPEGRepresentation(image, 1.0)
        do {
            try jpgImageData?.write(to: URL(fileURLWithPath: path), options: .atomic)
        } catch {
            print(error)
        }

        
    }
    
    func loadImageFromPath(path: String) -> UIImage? {
        
        let image = UIImage(contentsOfFile: path)
        
        if image == nil {
            
            print("missing image at: \(path)")
        }
        return image
        
    }

    
    // MARK: - Textfield delegates
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == nameField {
            guard let text = textField.text else { return true }
            let newLength = text.characters.count + string.characters.count - range.length
            return newLength <= 20 // Bool
        }
        else if textField == costField {
            guard let text = textField.text else { return true }
            let newLength = text.characters.count + string.characters.count - range.length
            return newLength <= 10 // Bool
        }
        
        return true
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    @IBAction func editModeTapped(_ sender: Any) {
        if editMode == false {
            editMode = true
            self.wishesCollView.reloadData()
            self.editButt.setTitle("Done", for: UIControlState.normal)
        }
        else {
            editMode = false
            self.wishesCollView.reloadData()
            self.editButt.setTitle("Edit", for: UIControlState.normal)
        }
    }
    
    func deleteWish(_ sender: UIButton) {
        let index : Int = (sender.layer.value(forKey: "index")) as! Int
        wishesArray.remove(at: index)
        self.wishesCollView.reloadData()
        self.saveWishes()
    }
    
    func editWish(_ sender: UIButton) {
        wishEdit = true
        editIndex = (sender.layer.value(forKey: "index")) as! Int
        self.addButtTapped(self)
        let wish = wishesArray[editIndex]
        self.nameField.text = wish.name
        self.costField.text = String(wish.cost)
        self.addPreview.image = self.loadImageFromPath(path: wish.picPath)
    }
    

    
    

    // MARK: - COLLECTION VIEW DELEGATES
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return wishesArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "wishCell", for: indexPath) as! wishCell
        
        let wish = wishesArray[indexPath.row]
        
        cell.nameLabel.text = wish.name.uppercased()
        cell.progressLabel.text = "$" + String(wish.count) + " of " + "$" + String(wish.cost)
        cell.backImageView.image = self.loadImageFromPath(path: wish.picPath)
        
        
        if editMode == false {
            cell.editButt.alpha = 0
            cell.deleteButt.alpha = 0
        }
        else {
            cell.editButt.alpha = 1
            cell.deleteButt.alpha = 1
        }
        
        if wish.completed {
            wishesArray.remove(at: indexPath.row)
        }
        
        cell.deleteButt.layer.setValue(indexPath.row, forKey: "index")
        cell.deleteButt.addTarget(self, action: #selector(deleteWish(_:)), for: UIControlEvents.touchUpInside)
        
        cell.editButt.layer.setValue(indexPath.row, forKey: "index")
        cell.editButt.addTarget(self, action: #selector(editWish(_:)), for: UIControlEvents.touchUpInside)
        
        saveWishes()

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return cellSize
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

