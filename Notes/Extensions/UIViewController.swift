//
//  UIViewController.swift
//  Notes
//
//  Created by Woon on 28/02/2019.
//  Copyright © 2019 Woon. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func showAlert(with title: String, and message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true)
    }
}
