//
//  PlacesTableViewCell.swift
//  Places
//
//  Created by Shivani Dosajh on 24/02/18.
//

import UIKit

class PlacesTableViewCell: UITableViewCell {

    @IBOutlet fileprivate weak var nameOfPlaceLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }


    func loadCell( withName name : String?) {
        nameOfPlaceLabel.text = name
    }
    
}
