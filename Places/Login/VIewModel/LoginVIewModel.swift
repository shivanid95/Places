//
//  LoginVIewModel.swift
//  Places
//
//  Created by Shivani Dosajh on 25/02/18.
//

import Foundation

protocol LoginViewDelegate : Loadable {
    // to enable/ disable error message
    func changeErrorLabel( shouldEnable : Bool , message : String?)
    
    // to toggle login button interactivity
    func shouldEnableLoginButton(_ value : Bool)
    
}

protocol LoginViewModel {
    
    var model           : LoginModel? { get set }
    var viewDelegate    : LoginViewDelegate? { get set}
    var emailId         : String? { get set }
    var password        : String? { get set}
    var isEmailIDValid  : Bool { get }
    
    func loginUser( completionHandler : @escaping(Bool , Error?) -> Void)
}

class LoginViewModelImplementation : LoginViewModel {
    
    var viewDelegate    : LoginViewDelegate?
    var model           : LoginModel?
    var emailId         : String? {
        didSet {
            viewDelegate?.shouldEnableLoginButton(enableLoginButton)
            if !isEmailIDValid {
                viewDelegate?.changeErrorLabel(shouldEnable: true, message: "Invalid Email Entered")
            } else {
                viewDelegate?.changeErrorLabel(shouldEnable: false, message: nil)
            }
        }
    }
    
    var password  : String? {
        didSet {
            viewDelegate?.shouldEnableLoginButton(enableLoginButton)
            if(isPasswordValid) {
                viewDelegate?.changeErrorLabel(shouldEnable: false, message: nil)
            } else {
                viewDelegate?.changeErrorLabel(shouldEnable: true, message: "Invalid Password Entered")
            }
        }
    }
//Mark: Validators
    
//To Validate email format
    var isEmailIDValid: Bool {
        if let email = emailId {
            let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
            
            let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
            return emailTest.evaluate(with: email)
        }
        return false
    }
    
    var isPasswordValid : Bool{
        if let pass = password , pass.count >= 5 {
            return true
        }
        return false
    }
//to enable login button only when both email and passwords are valid
    var enableLoginButton : Bool {
        return isEmailIDValid && isPasswordValid
    }
    
    
    func loginUser( completionHandler : @escaping(Bool , Error?) -> Void) {
        viewDelegate?.showLoader()
        model?.loginUser(email: emailId!, password: password!){ [weak self] in completionHandler($0 , $1)
            self?.viewDelegate?.hideLoader()
        }
    }
    
    
}
