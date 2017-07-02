//
//  ViewController.swift
//  TimeToGetSocial
//
//  Created by Daniel Ny on 2017-07-02.
//  Copyright © 2017 Daniel Ny. All rights reserved.
//

import UIKit
import FacebookLogin
import Firebase


class SignInVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    
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
                }
                
                
            })
            
        }
        
    }
    


}

