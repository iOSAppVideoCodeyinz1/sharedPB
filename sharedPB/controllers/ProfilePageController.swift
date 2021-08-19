//
//  ProfilePageController.swift
//  sharedPB
//
//  Created by Theo Yin on 8/19/21.
//

import UIKit
import Firebase

class ProfilePageController: UIViewController {
    
    @IBOutlet weak var profilePhotoView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBAction func pressedUploadPhoto(_ sender: Any) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            print("You must be on a real device!")
            imagePickerController.sourceType = .camera
        } else {
            print("You are probably on the simulator")
            imagePickerController.sourceType = .photoLibrary
        }
        
        present(imagePickerController, animated: true, completion: nil)
    }
    
    @IBAction func pressedDoneButton(_ sender: Any) {
        if let name = nameTextField.text {
            UserManager.shared.updateName(name: name)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UserManager.shared.beginListening(uid: Auth.auth().currentUser!.uid, changeListener: updateView)
    }
    
    func updateView() {
        nameTextField.text = UserManager.shared.name
        
        if UserManager.shared.photoUrl.count > 0 {
            ImageUtils.load(imageView: profilePhotoView, from: UserManager.shared.photoUrl)
        }
        
    }
    
    func uploadImage(_ image: UIImage) {
        if let imageData = ImageUtils.resize(image: image) {
            let storageRef = Storage.storage().reference().child(kCollectionUsers).child(Auth.auth().currentUser!.uid)
            let uploadTask = storageRef.putData(imageData, metadata: nil) { (metadata, error) in
                if let error = error {
                    print("Error uploading image: \(error)")
                    return
                }
                
                print("Upload complete")
                
                // You can also access to download URL after upload.
                storageRef.downloadURL { (url, error) in
                    if let error = error {
                        print("Error getting the download url: \(error)")
                        return
                    }
                    if let downloadURL = url {
                        // Uh-oh, an error occurred!
                        print("Got the download url: \(downloadURL)")
                        
                        UserManager.shared.updatePhotoUrl(photoUrl: downloadURL.absoluteString)
                        
                    }
                }
            }
            
        } else {
            print("Error getting image data")
        }
    }
}

extension ProfilePageController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey.editedImage] as! UIImage? {
            //            profilePhotoImageView.image = image
            uploadImage(image)
        } else if let image = info[UIImagePickerController.InfoKey.editedImage] as! UIImage? {
            //            profilePhotoImageView.image = image
            uploadImage(image)
        }
        
        picker.dismiss(animated: true)
    }
    
}
