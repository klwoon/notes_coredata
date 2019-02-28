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
    @IBOutlet weak var colorView: UIView!
    var category: Category?
    
    private enum Segue {
        static let color = "color"
    }
    
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
    
    private func setupColorView() {
        colorView.layer.cornerRadius = CGFloat(colorView.frame.width / 2.0)
        updateColorView()
    }
    
    private func updateColorView() {
        colorView.backgroundColor = category?.color
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        
        switch identifier {
        case Segue.color:
            guard let destination = segue.destination as? ColorViewController else {
                return
            }
            
            // Configure Destination
            destination.delegate = self
            destination.color = category?.color ?? .white
        default:
            break
        }
    }
}

extension CategoryViewController: ColorViewControllerDelegate {
    
    func controller(_ controller: ColorViewController, didPick color: UIColor) {
        category?.color = color
        // Update View
        updateColorView()
    }
    
}
