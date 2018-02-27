//
//  LoginViewController.swift
//  Places
//
//  Created by Shivani Dosajh on 24/02/18.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var mainStackViewCenterConstraint: NSLayoutConstraint!
    
    var viewModel : LoginViewModel? {
        didSet {
            viewModel?.viewDelegate = self
            viewModel?.model = LoginModelImplementation()
        }
    }
    
    //MARK:- Outlets
    @IBOutlet fileprivate weak var titleLabel: UILabel!
    
    @IBOutlet fileprivate weak var descripitonLabel: UILabel!
    
    @IBOutlet fileprivate weak var emailTextField: UITextField! {
        didSet {
            emailTextField.tag = 10
            emailTextField.delegate = self
        }
    }
    
    @IBOutlet fileprivate weak var passwordTextField: UITextField! {
        didSet {
            passwordTextField.tag = 20
            emailTextField.delegate = self
        }
    }
    
    @IBOutlet fileprivate weak var errorLabel: UILabel! {
        didSet {
            changeErrorLabel(shouldEnable: false, message: nil)
        }
    }
    
    @IBOutlet fileprivate weak var loginButton: UIButton! {
        didSet {
            shouldEnableLoginButton(false)
        }
    }
    
    //MARK:- Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = LoginViewModelImplementation()
        hideKeyboardWhenTappedAround()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- Actions
    
    @IBAction func didChangeEditing(_ sender: UITextField) {
        switch sender.tag {
        case 10 : viewModel?.emailId = sender.text
        case 20 : viewModel?.password = sender.text
        default : return
        }
    }
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        viewModel?.loginUser(completionHandler: { [weak self] (result , error) in
            if error != nil {
                self?.changeErrorLabel(shouldEnable: true, message: error!.localizedDescription)
            } else if result {
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: Constants.listOfPlacesVCNibName) as! ListOfPlacesTableViewController
                self?.show(vc, sender: self)
                
            }
        })}
    
    
}
// Delegate for UI related call backs from viewModel
extension LoginViewController : LoginViewDelegate , Loadable {
    
    func changeErrorLabel(shouldEnable: Bool, message: String?) {
        errorLabel.isHidden = !shouldEnable
        errorLabel.text = message
    }
    
    func shouldEnableLoginButton(_ value: Bool) {
        loginButton.isEnabled = value
        loginButton.backgroundColor = value ? #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1) : #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
    }
    //Mark : Loadable Methods
    
    func showLoader() {
        showLoadingView()
    }
    
    func hideLoader() {
        hideLoadingView()
    }
}

extension LoginViewController : UITextFieldDelegate {
   // MARK: - TexField Delegate
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
// Changing views when editing begins
        mainStackViewCenterConstraint.constant = -90
        titleLabel.isHidden = true
        descripitonLabel.isHidden = true
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
// Changing views when editing ends
        mainStackViewCenterConstraint.constant = 0
        titleLabel.isHidden = false
        descripitonLabel.isHidden = false
    }
}

