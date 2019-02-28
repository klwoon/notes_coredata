//
//  NoteViewController.swift
//  Notes
//
//  Created by Woon on 28/02/2019.
//  Copyright © 2019 Woon. All rights reserved.
//

import UIKit
import CoreData

class NoteViewController: UIViewController {
    
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var contentsTextView: UITextView!
    
    @IBOutlet weak var categoryLabel: UILabel!
    var note: Note?
    
    private enum Segue {
        static let categories = "categories"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Edit Note"
        setupView()
        setupNotificationHandling()
    }
    
    private func  setupNotificationHandling() {
        NotificationCenter.default.addObserver(self, selector: #selector(managedObjectContextObjectsDidChange(_:)), name: Notification.Name.NSManagedObjectContextObjectsDidChange, object: note?.managedObjectContext)
    }
    
    @objc private func managedObjectContextObjectsDidChange(_ notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        guard let updates = userInfo[NSUpdatedObjectsKey] as? Set<NSManagedObject> else { return }
        
        if (updates.filter { return $0 == note }).count > 0 {
            updateCategoryLabel()
        }
    }
    
    private func updateCategoryLabel() {
        categoryLabel.text = note?.category?.name ?? "No Category"
    }
    
    private func setupView() {
        setupTitleTextField()
        setupContentsTextView()
        updateCategoryLabel()
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        
        switch identifier {
        case Segue.categories:
            guard let destination = segue.destination as? CategoriesViewController else { return }
            destination.note = note
        default:
            break
        }
    }
}
