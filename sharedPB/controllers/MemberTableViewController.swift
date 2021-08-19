//
//  MemberTableViewController.swift
//  sharedPB
//
//  Created by Theo Yin on 8/18/21.
//

import UIKit
import Firebase

class MainPageCell: UITableViewCell {
    
}

class MemberTableViewController: UITableViewController {
    let kMemberCell = "MemberCell"
    var albumReference: DocumentReference!
    var membersListener: ListenerRegistration!
    var members = [String]()
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("Received reference: \(albumReference)")
//        startListening()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
//        albumReference = MembersManager.shared._collectionRef
        tableView.reloadData()
//        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Menu", style: UIBarButtonItem.Style.plain, target: self, action: #selector(showMenu))
    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return members.count
//    }
//
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//        let cell = tableView.dequeueReusableCell(withIdentifier: kMemberCell, for: indexPath)
//        cell.textLabel?.text = members[indexPath.row]
//        cell.detailTextLabel?.text = members[indexPath.row]
//        return cell
//    }
//
//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            self.members.remove(at: indexPath.row)
//            albumReference.setData([
//                "members": self.members
//            ])
//        }
//    }
//
//    @objc func showMenu (){
//
//        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
//
//        //configure
//
//        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
//
//        let createAction = UIAlertAction(title: "Add a Member", style: .default) { (action) in
//            self.addMember()
//        }
//
//        let deleteAction = UIAlertAction(title: "Delete Member", style: .default) { action in
//            self.setEditing(!self.isEditing, animated: true)
//        }
//
//        alertController.addAction(createAction)
//        alertController.addAction(deleteAction)
//        alertController.addAction(cancelAction)
//        present(alertController, animated: true, completion: nil)
//    }
//
//    func startListening(){
//        if(membersListener != nil) {
//            membersListener.remove()
//        }
//
//        membersListener = albumReference.addSnapshotListener { querySnapshot, error in
//            if querySnapshot != nil {
//                self.members.removeAll()
//                let data = querySnapshot!.data()
//                print(data)
//                let list = data!["members"] as! String
//                self.members = list.components(separatedBy: ", ")
//                self.tableView.reloadData()
//
//            } else {
//                print("Error getting movie quotes \(error!)")
//            }
//        }
//    }
//
//    @objc func addMember(){
//        print("pressed add Member")
//        let alertController = UIAlertController(title: "Add a Member", message: "", preferredStyle: UIAlertController.Style.alert)
//
//        //configure
//
//        alertController.addTextField { textfield in
//            textfield.placeholder = "Member Email"
//        }
//
//        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
//
//        let submitAction = UIAlertAction(title: "Submit", style: .default) { (action) in
//            //TODO: Add a quote
//            let newEmailTestField = alertController.textFields![0] as UITextField
//
//            self.members.append(newEmailTestField.text!)
//            let eStr = self.members.joined(separator: ", ")
//            self.albumReference.setData([
//                "members": eStr
//            ])
//
//
//        }
//
//        alertController.addAction(submitAction)
//        alertController.addAction(cancelAction)
//        present(alertController, animated: true, completion: nil)
//    }
//
}
