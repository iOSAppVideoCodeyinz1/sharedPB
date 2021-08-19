//
//  AlbumsController.swift
//  sharedPB
//
//  Created by Theo Yin on 8/18/21.
//

import UIKit
import Firebase

class AlbumsController: UITableViewController {
    var kAlbumCell = "AlbumCell"
    var kToMembersSegue = "ToMembersSegue"
    var kToPhotoBucketSegue = "ToPhotoBucketSegue"
    
    var albumsRef: CollectionReference!
    var albumsListener: ListenerRegistration!
    var albums = [Album]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showAddDialog))
        albumsRef = Firestore.firestore().collection("Albums")

    }
    
    @objc func showAddDialog() {
        print("pressed add Album")
        
        let alertController = UIAlertController(title: "Create a new Album", message: "", preferredStyle: UIAlertController.Style.alert)
        
        //configure
        
        alertController.addTextField { textfield in
            textfield.placeholder = "Album Name"
        }
        
        alertController.addTextField { textfield in
            textfield.placeholder = "Member Emails (Seperate by ', ')"
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) { (action) in
            //TODO: Add a quote
            let albumNameTextField = alertController.textFields![0] as UITextField
            let membersTextField = alertController.textFields![1] as UITextField
            var emails = membersTextField.text!.components(separatedBy: ", ")
            emails.append(Auth.auth().currentUser!.email!)
            let eStr = emails.joined(separator: ", ")
            
            self.albumsRef.addDocument(data: [
                "title": albumNameTextField.text,
                "members": eStr,
                "created": Timestamp.init(),
                "author": Auth.auth().currentUser!.uid,
                "owner": Auth.auth().currentUser!.email!,
            ])

            
        }
        
        
        alertController.addAction(submitAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()

        startListening()
    }

    func startListening(){
        if(albumsListener != nil) {
            albumsListener.remove()
        }
        var query = albumsRef.order(by: "created", descending: true).limit(to: 50)
        
        albumsListener = query.addSnapshotListener { querySnapshot, error in
            if querySnapshot != nil {
                self.albums.removeAll()
                querySnapshot?.documents.forEach({ documentSnapshot in
                    let data = documentSnapshot.data()
                    print(data)
                    let check = data["members"] as! String
                    let list = check.components(separatedBy: ", ")
                    if(list.contains(Auth.auth().currentUser!.email!)){
                        self.albums.append(Album(documentSnapshot: documentSnapshot))
                        self.tableView.reloadData()
                    }
                   
                })
            } else {
                print("Error getting movie quotes \(error!)")
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albums.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kAlbumCell, for: indexPath)
        cell.textLabel!.text = albums[indexPath.row].title
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return albums[indexPath.row].owner == Auth.auth().currentUser!.email
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let albumToDelete = albums[indexPath.row]
            albumsRef.document(albumToDelete.id).delete()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == kToMembersSegue {
//            if let indexPath = tableView.indexPathForSelectedRow {
//                MembersManager.shared.addNewMaybe(uid: String, members: String)
//            }
        }
        
        if segue.identifier == kToPhotoBucketSegue {
            if let indexPath = tableView.indexPathForSelectedRow {
                (segue.destination as! PhotoTableViewController).albumReference = albumsRef.document(albums[indexPath.row].id)
            }

        }
    }
}
