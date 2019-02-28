//
//  NoteTableViewCell.swift
//  Notes
//
//  Created by Woon on 28/02/2019.
//  Copyright © 2019 Woon. All rights reserved.
//

import UIKit

class NoteTableViewCell: UITableViewCell {
    
    // MARK: - Static properties
    static let reuseIdentifier = "NoteTableViewCell"
    
    // MARK: - properties
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var updatedAtLabel: UILabel!
    @IBOutlet weak var contentsLabel: UILabel!
    
    @IBOutlet weak var categoryColorView: UIView!
    // MARK: - Initialization
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
