//
//  UIViewController(ext).swift
//  Places
//
//  Created by Shivani Dosajh on 25/02/18.
//

import UIKit

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func showLoadingView() {
        
        let loadingView = UIView()
        loadingView.tag = 1098
        loadingView.frame = CGRect(x: Constants.Screen.width/2-40, y: Constants.Screen.height/2-80, width: 80, height: 80)
        loadingView.backgroundColor = #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1)
        loadingView.clipsToBounds = true
        loadingView.layer.cornerRadius = 10
        
        let actInd = UIActivityIndicatorView()
        actInd.tag = 1099
        actInd.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        actInd.transform = CGAffineTransform(scaleX: 2, y: 2)
        actInd.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.white
        actInd.center = CGPoint(x: loadingView.frame.size.width / 2, y: loadingView.frame.size.height / 2)
        actInd.startAnimating()
        
        loadingView.addSubview(actInd)
        self.view.addSubview(loadingView)
    }
    
    func hideLoadingView() {
        for subViews in self.view.subviews {
            if subViews.tag == 1098 {
                for subview in subViews.subviews {
                    if subview.tag == 1099 {
                        subview.removeFromSuperview()
                    }
                }
                subViews.removeFromSuperview()
            }
        }
    }
    
}
