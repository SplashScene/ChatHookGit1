//
//  ImageExtensions.swift
//  ChatHook8
//
//  Created by Kevin Farm on 9/28/16.
//  Copyright © 2016 splashscene. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import AVFoundation

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage{
            selectedImageFromPicker = editedImage
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage{
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker{
            if photoChoice == "Profile"{
                DataService.ds.putInFirebaseStorage(whichFolder: PROFILE_IMAGES, withOptImage: selectedImage, withOptVideoNSURL: nil, withOptUser: nil, withOptText: nil, withOptRoom: nil, withOptCityAndState: nil, withOptDict: nil)
                self.profileImageView.image = selectedImage
            }else{
                hudView = HudView.hudInView(view: self.view, animated: true)
                hudView?.isHidden = false
                hudView?.text = "Uploading..."
                DataService.ds.putInFirebaseStorage(whichFolder: GALLERY_IMAGES, withOptImage: selectedImage, withOptVideoNSURL: nil, withOptUser: nil, withOptText: nil, withOptRoom: nil, withOptCityAndState: nil, withOptDict: nil)
            }
        }
        
        if let video = info["UIImagePickerControllerMediaURL"] as? NSURL{
            DataService.ds.putInFirebaseStorage(whichFolder: GALLERY_IMAGES, withOptImage: nil, withOptVideoNSURL: video, withOptUser: nil, withOptText: nil, withOptRoom: nil, withOptCityAndState: nil, withOptDict: nil)
        }
        
        dismiss(animated: true, completion: nil)
    }
   
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func takePhotoWithCamera(){
        let imagePicker = UIImagePickerController()
            imagePicker.sourceType = .camera
            imagePicker.cameraDevice = .front
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    
    func choosePhotoFromLibrary(){
        let imagePicker = UIImagePickerController()
            imagePicker.sourceType = .photoLibrary
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    
    func pickPhoto(){
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            showPhotoMenu()
        }else{
            choosePhotoFromLibrary()
        }
    }
    
    func showPhotoMenu(){
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        let takePhotoAction = UIAlertAction(title: "Take Photo", style: .default, handler: {
            _ in
            self.takePhotoWithCamera()
        })
        alertController.addAction(takePhotoAction)
        
        let chooseFromLibraryAction = UIAlertAction(title: "Choose From Library", style: .default, handler: {
            _ in
            self.choosePhotoFromLibrary()
        })
        alertController.addAction(chooseFromLibraryAction)
        
        present(alertController, animated: true, completion: nil)
    }
}

extension ChatViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func takePhotoWithCamera(){
        let imagePicker = UIImagePickerController()
            imagePicker.sourceType = .camera
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }

    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage{
            selectedImageFromPicker = editedImage
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage{
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker{
            DataService.ds.putInFirebaseStorage(whichFolder: MESSAGE_IMAGES, withOptImage: selectedImage, withOptVideoNSURL: nil, withOptUser: user, withOptText: nil, withOptRoom: nil, withOptCityAndState: nil, withOptDict: nil)
        }
        
        if let video = info["UIImagePickerControllerMediaURL"] as? NSURL{
            DataService.ds.putInFirebaseStorage(whichFolder: MESSAGE_IMAGES, withOptImage: nil, withOptVideoNSURL: video, withOptUser: user, withOptText: nil, withOptRoom: nil, withOptCityAndState: nil, withOptDict: nil)
        }
        
        self.finishSendingMessage()
        dismiss(animated: true, completion: nil)

    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

extension IntroViewController:UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func takePhotoWithCamera(){
        let imagePicker = UIImagePickerController()
            imagePicker.sourceType = .camera
            imagePicker.cameraDevice = .front
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    
    func choosePhotoFromLibrary(){
        let imagePicker = UIImagePickerController()
            imagePicker.sourceType = .photoLibrary
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    
    func pickPhoto(){
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            showPhotoMenu()
        }else{
            choosePhotoFromLibrary()
        }
    }
    
    func showPhotoMenu(){
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        let takePhotoAction = UIAlertAction(title: "Take Photo", style: .default, handler: {
            _ in
            self.takePhotoWithCamera()
        })
        alertController.addAction(takePhotoAction)
        
        let chooseFromLibraryAction = UIAlertAction(title: "Choose From Library", style: .default, handler: {
            _ in
            self.choosePhotoFromLibrary()
        })
        alertController.addAction(chooseFromLibraryAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        guard let image = info[UIImagePickerControllerEditedImage] as? UIImage else {
            print("Info did not have the required UIImage for the Original Image")
            dismiss(animated: true, completion: nil)
            return
        }
        
        profileImageView.image = image
        profileImageChanged = true
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
}

extension PostsVC:UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func takePhotoWithCamera(){
        let imagePicker = UIImagePickerController()
            imagePicker.sourceType = .camera
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage{
            selectedImageFromPicker = editedImage
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage{
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker{
            postedImage = selectedImage
            imageSelectorView.image = postedImage
        }
        
        if let video = info["UIImagePickerControllerMediaURL"] as? NSURL{
            postedVideo = video
            imageSelectorView.image = UIImage(named: "movieIcon")
        }
        self.postButton.isUserInteractionEnabled = true
        self.postButton.alpha = 1.0
        dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
}//end extension


