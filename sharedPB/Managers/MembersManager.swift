//
//  MembersManager.swift
//
//  Created by Theo Yin on 8/18/21.
//

import Foundation

import Firebase


let kCollectionMembers = "Members"
let kKeyList = "list"

class MembersManager {
    var _collectionRef: CollectionReference
    var _document: DocumentSnapshot?
    var _membersListener: ListenerRegistration?
    
    static let shared = MembersManager()
    
    init() {
        _collectionRef = Firestore.firestore().collection(kCollectionMembers)
    }
    
    func addNewMaybe(uid: String, members: String) {
        let memberRef = _collectionRef.document(uid)
        memberRef.getDocument { (documentSnapshot, error) in
            if let error = error {
                print("Error getting user: \(error)")
                return
            }
            if let documentSnapshot = documentSnapshot {
                if documentSnapshot.exists {
                    print("There is already a User object for this member List. Do nothing")
                } else {
                    print("Creating a MemberList with document id \(uid)")
                    memberRef.setData([
                        kKeyList: members ?? "",
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
        _membersListener?.remove()
    }
    
    func updateName(name: String) {
        let userRef = _collectionRef.document(Auth.auth().currentUser!.uid)
        userRef.updateData([
            kKeyName: name
        ])
    }

    var list: String {
        get {
            if let value = _document?.get(kKeyList) {
                return value as! String
            }
            return ""
        }
    }
    
}

