//
//  AlbumSideNavController.swift
//  sharedPB
//
//  Created by Theo Yin on 8/18/21.
//

import UIKit
import Firebase

class AlbumSideNavController: UIViewController {
    var tableViewController: AlbumsController {
        let navController = presentingViewController as! UINavigationController
        return navController.viewControllers.last as! AlbumsController
    }
    
    @IBAction func pressedSignOutButton(_ sender: Any) {
        print("auth sign out")
        do {
            try Auth.auth().signOut()
        } catch {
            print("Sign out error")
        }
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func pressedDeleteButton(_ sender: Any) {
        print("editing mode \(tableViewController.isEditing)")
        tableViewController.setEditing(!tableViewController.isEditing, animated: true)
        dismiss(animated: false, completion: nil)
    }
}
