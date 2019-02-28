//
//  AddCategoryViewController.swift
//  Notes
//
//  Created by Woon on 28/02/2019.
//  Copyright © 2019 Woon. All rights reserved.
//

import UIKit
import CoreData

class AddCategoryViewController: UIViewController {
    
    @IBOutlet var nameTextField: UITextField!
    
    var managedObjectContext: NSManagedObjectContext?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Add Category"
        
        setupView()
    }
    
    private func setupView() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(save(sender:)))
    }
    
    @objc private func save(sender: UIBarButtonItem) {
        guard let managedObjectContext = managedObjectContext else { return }
        guard let name = nameTextField.text, !name.isEmpty else {
            showAlert(with: "Name Missing", and: "Your category doesn't have a name.")
            return
        }
        
        // Create Category
        let category = Category(context: managedObjectContext)
        
        // Configure Category
        category.name = nameTextField.text
        
        // Pop View Controller
        _ = navigationController?.popViewController(animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        nameTextField.becomeFirstResponder()
    }
}
