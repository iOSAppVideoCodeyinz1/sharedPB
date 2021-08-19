//
//  DefaultClasses.swift
//  sharedPB
//
//  Created by Theo Yin on 8/18/21.
//

import Foundation
import Firebase

class Album {
    var id: String
    var owner: String
    var title: String
    var members: String
    
    init(owner: String, title: String, members: String, id:String) {
        self.owner = owner
        self.title = title
        self.members = members
        self.id = id
    }
    
    init(documentSnapshot: DocumentSnapshot) {
        let data = documentSnapshot.data()!
        self.owner = data["owner"] as! String
        self.title = data["title"] as! String
        self.members = data["members"] as! String
        self.id = documentSnapshot.documentID
    }

}

class Photo {
    var url: String
    var caption: String
    var id: String?
    
    
    
    init(url: String, caption: String){
        self.url = url
        self.caption = caption
    }
    
    init(documentSnapshot: DocumentSnapshot) {
        self.id = documentSnapshot.documentID
        let data = documentSnapshot.data()!
        self.url = data["imgUrl"] as! String
        self.caption = data["imgCaption"] as! String
    }
}

