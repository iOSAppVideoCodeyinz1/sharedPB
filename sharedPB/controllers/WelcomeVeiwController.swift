//
//  WelcomeVeiwController.swift
//  sharedPB
//
//  Created by Theo Yin on 8/18/21.
//

import UIKit
import FirebaseAuthUI
import FirebaseEmailAuthUI
import FirebaseGoogleAuthUI

class WelcomeVeiwController: UIViewController, FUIAuthDelegate  {
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBAction func pressedStartButton(_ sender: Any) {
        showLoginVC()
    }
    
    var authListenerHandle : AuthStateDidChangeListenerHandle!
    let kSignedInSegue = "SignedInSegue"
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        signUpButton.layer.cornerRadius = 12

        authListenerHandle = Auth.auth().addStateDidChangeListener { auth, user in
            if(Auth.auth().currentUser == nil){
                print("you messed up, go back to login page")
                self.navigationController?.popViewController(animated: true)
            }else {
                print("Someone is already signed in")
                self.performSegue(withIdentifier: self.kSignedInSegue, sender: self)
            }
        }
    }
    
    func showLoginVC() {
        let authUI = FUIAuth.defaultAuthUI()
        let providers: [FUIAuthProvider] = [
            FUIEmailAuth(),
            FUIGoogleAuth(),
            
        ]
        authUI?.providers = providers
        let authViewController = authUI!.authViewController()
        self.present(authViewController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if Auth.auth().currentUser != nil {
            do {
                try Auth.auth().signOut()

            } catch {
                print("sign out error")
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == kSignedInSegue {
            UserManager.shared.addNewUserMaybe(uid: Auth.auth().currentUser!.uid, name: Auth.auth().currentUser!.displayName, photoUrl: Auth.auth().currentUser!.photoURL?.absoluteString)
        }
    }
}
