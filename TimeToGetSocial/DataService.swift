//
//  DataService.swift
//  TimeToGetSocial
//
//  Created by Daniel Ny on 2017-07-03.
//  Copyright © 2017 Daniel Ny. All rights reserved.
//

import Foundation
import Firebase


let DB_BASE = Database.database().reference()

class DataSerivce {
    
    static let ds = DataSerivce()
    
    private var _REF_BASE = DB_BASE
    private var _REF_POSTS = DB_BASE.child("posts")
    private var _REF_USERS = DB_BASE.child("users")
    
    
    var REF_BASE: DatabaseReference {
        return _REF_BASE
    }
    
    var REF_POSTS: DatabaseReference {
        return _REF_POSTS
    }
    
    var REF_USERS: DatabaseReference {
        return _REF_USERS
    }
    
    func CreateFirebaseDBUser(uid: String, userData: Dictionary<String, String>) {
        //uid blir kombinationen som ligger till grund för användaren, Dictionaryn är provider och facebook eller farebase
        REF_USERS.child(uid).updateChildValues(userData)
        
    }
    
    
    
}
