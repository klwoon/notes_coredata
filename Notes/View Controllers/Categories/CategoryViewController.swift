//
//  CategoryViewController.swift
//  Notes
//
//  Created by Woon on 28/02/2019.
//  Copyright © 2019 Woon. All rights reserved.
//

import UIKit

class CategoryViewController: UIViewController {
    
    @IBOutlet var nameTextField: UITextField!
    var category: Category?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Edit Category"
        setupView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let name = nameTextField.text, !name.isEmpty {
            category?.name = name
        }
    }
    private func setupView() {
        nameTextField.text = category?.name
    }
}
