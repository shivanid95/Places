//
//  UIView(ext).swift
//  Places
//
//  Created by Shivani Dosajh on 27/02/18.
//

import UIKit

extension UIView {
    func dropShadow() {
        dropShadow(color: UIColor.black, radius: 5, opacity: 0.3 )
    }
    
    func dropShadow( color: UIColor , radius: Float , opacity: Float ) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = CGSize(width: -1, height: 1)
        self.layer.shadowRadius = CGFloat( radius)
    }
}
