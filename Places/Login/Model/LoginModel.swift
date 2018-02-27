//
//  LoginModel.swift
//  Places
//
//  Created by Shivani Dosajh on 25/02/18.
//

import Foundation

import FirebaseAuth
// Data model for login module

protocol LoginModel {
    
    // Uses Firebase to authenicate user and login
    func loginUser( email : String , password : String , completionHandler : @escaping(Bool, Error?) -> Void)
    
}

// Implementation of the login Module

class LoginModelImplementation : LoginModel {
    
    func loginUser( email : String , password : String , completionHandler : @escaping(Bool, Error?) -> Void) {
        
        DispatchQueue.global().async {
            Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
                if error != nil {
                    completionHandler(false , error)
                } else {
                    completionHandler(true , error)
                }
            }
            
        }
    }
    
}

