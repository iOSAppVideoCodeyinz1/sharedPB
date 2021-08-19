//
//  PhotoTableViewController.swift
//  sharedPB
//
//  Created by Theo Yin on 8/18/21.
//

import UIKit
import Firebase

class PhotoTableViewController: UITableViewController {
    var albumReference: DocumentReference!
    var photosRef: CollectionReference?
    var pbListener: ListenerRegistration!
    var isShowingAll = true
    let kPhotoCell = "PhotoCell"
    let kToPhotoDetailSegue = "ToPhotoDetailSegue"
    var photos = [Photo]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Menu", style: UIBarButtonItem.Style.plain, target: self, action: #selector(showMenu))
        print("photo ref is \(String(describing: photosRef))")
        
        photosRef!.order(by: "created", descending: true).limit(to: 50).addSnapshotListener { querySnapshot, error in
            self.photos.removeAll()
            if let querySnapshot = querySnapshot {
                querySnapshot.documents.forEach { queryDocumentSnapshot in
                    print(queryDocumentSnapshot.documentID)
                    print(queryDocumentSnapshot.data())
                    self.photos.append(Photo(documentSnapshot: queryDocumentSnapshot))
                    self.tableView.reloadData()
                }
            } else {
                print("error getting data ")
            }
        }

    }
    
    @objc func showMenu (){

        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        //configure
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        let createAction = UIAlertAction(title: "Create Photo", style: .default) { (action) in
            self.showAddPhotoDialog()
        }
            
        let deleteAction = UIAlertAction(title: "Delete Photo", style: .default) { action in
            self.setEditing(!self.isEditing, animated: true)
        }
        
        alertController.addAction(createAction)
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    @objc func showAddPhotoDialog(){
        //CRUD
        let alertController = UIAlertController(title: "Create a new Photo Entry", message: "", preferredStyle: UIAlertController.Style.alert)
        
        //configure
        alertController.addTextField { urlTextField in
            urlTextField.placeholder = "URL"
        }
        
        alertController.addTextField { capTextField in
            capTextField.placeholder = "caption"
        }
        
        let submitAction = UIAlertAction(title: "Create", style: UIAlertAction.Style.default) { action in
            let urlTextField = alertController.textFields![0] as UITextField
            let capTextField = alertController.textFields![1] as UITextField
            self.photosRef!.addDocument(data: [
                "owner": Auth.auth().currentUser!.uid,
                "imgUrl": urlTextField.text!,
                "imgCaption": capTextField.text!,
                "created": Timestamp.init()
            ])
        }
        let camaraAction = UIAlertAction(title: "Add a photo from camara", style: .default) { action in
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
            
            self.present(imagePickerController, animated: true, completion: nil)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil)
        
        alertController.addAction(cancelAction)
        alertController.addAction(submitAction)
        alertController.addAction(camaraAction)

        present(alertController, animated: true, completion: nil)
    }
    
    func uploadImage(_ image: UIImage) {
        if let imageData = ImageUtils.resize(image: image) {
            let storageRef = Storage.storage().reference()
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        photosRef = albumReference.collection("photoBucket")
        print("photo ref is \(String(describing: photosRef))")
    }
    

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kPhotoCell, for: indexPath)
        //configure cell
        cell.textLabel?.text = photos[indexPath.row].caption
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete){
            let pbToDelete = photos[indexPath.row]
            photosRef!.document(pbToDelete.id!).delete()
        }
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == kToPhotoDetailSegue {
            if let indexPath = tableView.indexPathForSelectedRow {
                (segue.destination as! PhotoDetailController).pb = photos[indexPath.row]
                (segue.destination as! PhotoDetailController).pbRef = photosRef!.document(photos[indexPath.row].id!)
            }
        }
    }
}


extension PhotoTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
