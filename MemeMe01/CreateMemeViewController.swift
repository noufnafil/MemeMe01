//
//  ViewController.swift
//  MemeMe01
//
//  Created by nouf alharbi on 1/26/19.
//  Copyright © 2019 nouf alharbi. All rights reserved.
//

import UIKit

class CreateMemeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {

    //Variables
    
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var bottomField: UITextField!
    @IBOutlet weak var topField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var navBar: UIToolbar!
    @IBOutlet weak var toolBar: UIToolbar!
    
    
    let textDelegate = TextField()
    
    //Enabling/disabling camera button
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
        
    }
    
    //Unsubscribing from notification
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        

        attributes(textField: topField)
        attributes(textField: bottomField)

          //Setting the delegates for text fields
        self.bottomField.delegate = textDelegate
        self.topField.delegate=textDelegate
        
    }
    
    //MARK: - text fields attributes
    func attributes(textField: UITextField)
    {
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = .center
        textField.backgroundColor = UIColor.clear
        textField.borderStyle = UITextBorderStyle.none
    }
    
    
    
    //Album image picker source
    @IBAction func pickImage(_ sender: Any) {
        openImagePicker(UIImagePickerControllerSourceType.photoLibrary)
            }
 
    //Camera image picker source
    @IBAction func pickImageCamera(_ sender: Any) {
        openImagePicker(UIImagePickerControllerSourceType.camera)
        
    }
    
    
    func openImagePicker(_ type: UIImagePickerControllerSourceType){
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = type
        present(picker, animated: true, completion: nil)
    }
    
    
    @IBAction func bottom(_ sender: Any) {
        subscribeToKeyboardNotifications()
    }
    
    //imagePickerController
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let picker = info[UIImagePickerControllerOriginalImage] as? UIImage
        {
            imageView.contentMode = .scaleAspectFit
            imageView.image = picker
            shareButton.isEnabled = imageView.image != nil
            
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: -keyboardWillShow
    @objc func keyboardWillShow(_ notification:Notification) {
        if bottomField.isFirstResponder {
            view.frame.origin.y = 0 - getKeyboardHeight(notification)
        }
    }
    
    @objc func keyboardWillHide(_ notification:Notification) {
        
        view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    //MARK: -subscribeToKeyboardNotifications
    func subscribeToKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    func unsubscribeFromKeyboardNotifications() {
        
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
        
    }

    let memeTextAttributes: [String:Any] = [
        NSAttributedStringKey.strokeColor.rawValue: UIColor.black, /* TODO: fill in appropriate UIColor */
        NSAttributedStringKey.foregroundColor.rawValue: UIColor.white,
        NSAttributedStringKey.font.rawValue: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedStringKey.strokeWidth.rawValue: -6]
 

    //struct for meme attributes
    struct Meme {
        var topText: String
        var bottomText: String
        var originalImage: UIImage
        var memedImage: UIImage
        
    }
    
    //MARK: -Method for generating the meme
    func generateMemedImage() -> UIImage {
        
        //TODO: Hide toolbar and navbar
        hideToolbars(true)

        
        //Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        //TODO: Show toolbar and navbar
        hideToolbars(false)
        
        return memedImage
    }
    func hideToolbars(_ hide: Bool) {
        toolBar.isHidden=hide
        navBar.isHidden=hide
    }
    
    
    //Saving the meme
    func save() {
        let memedImage = generateMemedImage()
        _ = Meme(topText: topField.text!, bottomText: bottomField.text!, originalImage: imageView.image!, memedImage: memedImage)
    }
    
    //MARK: -The activity view
    @IBAction func activityView(_ sender: Any) {
        
        let memedImage = generateMemedImage()
        let controller = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        controller.completionWithItemsHandler = { activity, completed, items, error in
            if completed{

                self.save()
               self.dismiss(animated: true, completion: nil)
                
            }
        }
   
        self.present(controller, animated: true, completion: nil)
    }
    
    


}

