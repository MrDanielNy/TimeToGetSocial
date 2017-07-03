//
//  ViewController.swift
//  TimeToGetSocial
//
//  Created by Daniel Ny on 2017-07-02.
//  Copyright © 2017 Daniel Ny. All rights reserved.
//

//KeychainValue.stringForKey -> defaultKeychainWrapper.set

import UIKit
import FacebookLogin
import Firebase
import SwiftKeychainWrapper


class SignInVC: UIViewController {

    @IBOutlet weak var emailField: FancyField!
    @IBOutlet weak var pswField: FancyField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        if let _ = KeychainWrapper.standard.string(forKey: KEY_UID) {
            performSegue(withIdentifier: "goToFeed", sender: nil)
        }
    }

    @IBAction func facebookBtnTapped(_ sender: Any) {
        let loginManager = LoginManager()
        loginManager.logIn([ .email ], viewController: self) { loginResult in
            print(loginResult)
            switch loginResult {
            case .failed(let error):
                print("ADGJMP: \(error)")
            case .cancelled:
                print("ADGJMP: User cancelled login.")
            case .success(let grantedPermissions, let declinedPermissions, let accessToken):
                print("ADGJMP: Logged in!")
                let creditential = Firebase.FacebookAuthProvider.credential(withAccessToken: accessToken.authenticationToken)
                firebaseAuth(creditential: creditential)
                
            }
        }
        
        func firebaseAuth(creditential: AuthCredential) {
            //   Auth.auth().signIn(with: AuthCredential, ?)
            Auth.auth().signIn(with: creditential, completion: { (user, error) in
                if error != nil {
                    print("ADGJMP: Unable to auth with Firebase. \(String(describing: error))")
                } else {
                    print("ADGJMP: Successfully auth with firebase")
                    if let user = user {
                        let userData = ["provider": creditential.provider]
                        self.completeSignin(user: user.uid, userData: userData)
                    }
                }
            })
        }
    }
    
    @IBAction func signinTapped(_ sender: Any) {
        if let mail = emailField.text, let psw = pswField.text {
            Auth.auth().signIn(withEmail: mail, password: psw, completion: { (user, error) in
                if error == nil {
                    print("ADGJMP: User authenticated with firebase")
                    if let user = user {
                        let userData = ["provider": user.providerID]
                        self.completeSignin(user: user.uid, userData: userData)
                    }
                } else {
                    Auth.auth().createUser(withEmail: mail, password: psw, completion: { (user, error) in
                        if error != nil {
                            print("ADGJMP: Unable to authenticate User with email")
                        } else {
                            print("ADGJMP: Successfully authenticated with Firebase")
                            if let user = user {
                                let userData = ["provider": user.providerID]
                                self.completeSignin(user: user.uid, userData: userData)
                            }
                        }
                    })
                }
                
            })
        }
        
    }
    
    func completeSignin(user: String, userData:  Dictionary<String, String>) {
        DataSerivce.ds.CreateFirebaseDBUser(uid: user, userData: userData)
        KeychainWrapper.standard.set(user, forKey: KEY_UID)
        print("ADGJMP: Standard key set by completeSignin")
        performSegue(withIdentifier: "goToFeed", sender: nil)
    }


}

