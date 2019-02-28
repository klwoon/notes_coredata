//
//  NoteViewController.swift
//  Notes
//
//  Created by Woon on 28/02/2019.
//  Copyright © 2019 Woon. All rights reserved.
//

import UIKit

class NoteViewController: UIViewController {
    
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var contentsTextView: UITextView!
    
    var note: Note?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Edit Note"
        setupView()
    }
    
    private func setupView() {
        setupTitleTextField()
        setupContentsTextView()
    }
    
    private func setupTitleTextField() {
        titleTextField.text = note?.title
    }
    
    private func setupContentsTextView() {
        contentsTextView.text = note?.contents
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if let title = titleTextField.text, !title.isEmpty {
            note?.title = title
        }
        note?.updatedAt = Date()
        note?.contents = contentsTextView.text
    }
}
