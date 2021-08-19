//
//  UserManager.swift
//  sharedPB
//
//  Created by Theo Yin on 8/18/21.
//

import Foundation

import Firebase

let kCollectionUsers = "Users"
let kKeyName = "name"
let kKeyPhotoUrl = "photoUrl"

class UserManager {
    var _collectionRef: CollectionReference
    var _document: DocumentSnapshot?
    var _userListener: ListenerRegistration?
    
    static let shared = UserManager()
    
    init() {
        _collectionRef = Firestore.firestore().collection(kCollectionUsers)
    }
    
    func addNewUserMaybe(uid: String, name: String?, photoUrl: String?) {
        let userRef = _collectionRef.document(uid)
        userRef.getDocument { (documentSnapshot, error) in
            if let error = error {
                print("Error getting user: \(error)")
                return
            }
            if let documentSnapshot = documentSnapshot {
                if documentSnapshot.exists {
                    print("There is already a User object for this auth user. Do nothing")
                } else {
                    print("Creating a User with document id \(uid)")
                    userRef.setData([
                        kKeyName: name ?? "",
                        kKeyPhotoUrl: photoUrl ?? ""
                    ])
                }
            }
        }
    }
    
    func beginListening(uid: String, changeListener: (() -> Void)? ) {
        stopListening()
        let userRef = _collectionRef.document(uid)
        userRef.addSnapshotListener { (documentSnapshot, error) in
            if let error = error {
                print("Error listening for user: \(error)")
                return
            }
            if let documentSnapshot = documentSnapshot {
                self._document = documentSnapshot
                changeListener?()
            }
        }
    }
    
    func stopListening() {
        _userListener?.remove()
    }
    
    func updateName(name: String) {
        let userRef = _collectionRef.document(Auth.auth().currentUser!.uid)
        userRef.updateData([
            kKeyName: name
        ])
    }
    func updatePhotoUrl(photoUrl: String) {
        let userRef = _collectionRef.document(Auth.auth().currentUser!.uid)
        userRef.updateData([
            kKeyPhotoUrl: photoUrl
        ])
    }
    
    var name: String {
        get {
            if let value = _document?.get(kKeyName) {
                return value as! String
            }
            return ""
        }
    }
    
    var photoUrl: String {
        get {
            if let value = _document?.get(kKeyPhotoUrl) {
                return value as! String
            }
            return ""
        }
    }
    
    var email: String {
        return Auth.auth().currentUser!.email!
    }
    
}
