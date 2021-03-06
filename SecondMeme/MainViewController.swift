//
//  MainViewController.swift
//  SecondMeme
//
//  Created by ziming li on 2017-06-16.
//  Copyright © 2017 ziming li. All rights reserved.
//

import Foundation
import UIKit

class MainViewController: UIViewController{
    // MARK: Connection Initializations
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var topBar: UIToolbar!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    
    // Mark: "Impact" font, all caps, white with a black outline
    let memeTextAttributes:[String:Any] = [
        NSStrokeColorAttributeName: UIColor.black,
        NSForegroundColorAttributeName: UIColor.white,
        NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName: -3.0]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure(textField: topTextField, text: "TOP")
        configure(textField: bottomTextField, text: "BOTTOM")
    }
    
    // set delegation, text, attribtues, etc ...
    func configure(textField: UITextField, text: String){
        textField.delegate = self
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = .center
        textField.text = text
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        shareButton.isEnabled = !(self.imagePickerView.image == nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Disabling the Camera Button
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    @IBAction func pickAnImageFromAlbum(_ sender: Any) {
        presentImagePickerWith(sourceType: .photoLibrary)
    }
    
    // MARK: Camera Methods
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
        presentImagePickerWith(sourceType: .camera)
    }
    
    // ----------Keyboard Methods---------- //
    // MARK: Keyboard Adjustments - Show
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
    func keyboardWillShow(_ notification:Notification) {
        if bottomTextField.isFirstResponder{
            // old: view.frame.origin.y -= getKeyboardHeight(notification)
            // Better slide up view
            view.frame.origin.y = getKeyboardHeight(notification) * (-1)
        }
    }
    
    // MARK: Keyboard Adjustments - Hide
    func keyboardWillHide(_ notification:Notification) {
        if bottomTextField.isFirstResponder{
            // old: view.frame.origin.y += getKeyboardHeight(notification)
            view.frame.origin.y = 0
        }
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    
    
    // ----------Top Tool Bar Methods---------- //
    
    // MARK: Topbar - Share
    @IBAction func share(_ sender: Any) {
        
        let memedimage = generateMemedImage()
        
        let activityView = UIActivityViewController(activityItems: [memedimage], applicationActivities: nil)
        
        self.present(activityView, animated: true, completion: nil)
        
        activityView.completionWithItemsHandler = completionHandler
        
    }
    
    func completionHandler(activityType: UIActivityType?, shared: Bool, items: [Any]?, error: Error?) {
        if (shared) {
            self.save()
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    // MARK: Creating MEME Object
    func save() {
        // Create the meme
        let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: imagePickerView.image!, memedImage: generateMemedImage())
        
        // Add it to the memes array in the Applicaton Delegate
        let object  = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
    }

    
    func generateMemedImage() -> UIImage {
        
        // TODO: Hide toolbar and navbar
        configHiddenBars(hidden: true)
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        // TODO: Show toolbar and navbar
        configHiddenBars(hidden: false)
        
        return memedImage
    }
    
    func configHiddenBars(hidden: Bool) {
        toolBar.isHidden = hidden
        topBar.isHidden = hidden
    }
    
    // MARK: Topbar - Cancel
    @IBAction func cancel(_ sender: Any) {
        /*
        imagePickerView.image = nil
        topTextField.text = "TOP"
        bottomTextField.text = "BOTTOM"
        */
        dismiss(animated: true, completion: nil)
    }
    
}

extension MainViewController: UIImagePickerControllerDelegate {
    // MARK: Image Picker Controller Methods
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imagePickerView.image = image
            imagePickerView.contentMode = .scaleAspectFit
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func presentImagePickerWith(sourceType: UIImagePickerControllerSourceType){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = sourceType
        present(imagePicker, animated: true, completion: nil)
    }
}

extension MainViewController: UINavigationControllerDelegate {
    
}

extension MainViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if (textField.text == "TOP")||(textField.text == "BOTTOM") {
            textField.text = ""
        }
    }
    
    // Dismiss the keyboard after pressing "Enter"
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
