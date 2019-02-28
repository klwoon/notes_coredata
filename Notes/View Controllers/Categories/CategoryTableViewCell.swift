//
//  CategoryTableViewCell.swift
//  Notes
//
//  Created by Woon on 28/02/2019.
//  Copyright © 2019 Woon. All rights reserved.
//

import UIKit

class CategoryTableViewCell: UITableViewCell {
    
    @IBOutlet var nameLabel: UILabel!
    
    static let reuseIdentifier = "CategoryTableViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
