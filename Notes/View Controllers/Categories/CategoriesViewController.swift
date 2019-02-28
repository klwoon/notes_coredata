//
//  CategoriesViewController.swift
//  Notes
//
//  Created by Woon on 28/02/2019.
//  Copyright © 2019 Woon. All rights reserved.
//

import UIKit
import CoreData

class CategoriesViewController: UIViewController {
    
    @IBOutlet var messageLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var note: Note?
    
    fileprivate lazy var fetchedResultsController: NSFetchedResultsController<Category> = {
        guard let context = self.note?.managedObjectContext else {
            fatalError("No managed object context found")
        }
        let request: NSFetchRequest<Category> = Category.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        let controller = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil)
        controller.delegate = self
        return controller
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Categories"
        
        setupView()
        
        do {
            try fetchedResultsController.performFetch()
        } catch let error {
            print("Unable to Perform Fetch Request")
            print("\(error), \(error.localizedDescription)")
        }
        updateView()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let id = segue.identifier else { return }
        switch id {
        case Segue.AddCategory:
            guard let destination = segue.destination as? AddCategoryViewController else { return }
            destination.managedObjectContext = note?.managedObjectContext
        case Segue.Category:
            guard let destination = segue.destination as? CategoryViewController, let cell = sender as? CategoryTableViewCell, let indexPath = tableView.indexPath(for: cell) else { return }
            let category = fetchedResultsController.object(at: indexPath)
            destination.category = category
        default:
            break
        }
    }
    
    private func setupView() {
        messageLabel.text = "You don't have any categories yet"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(add(sender:)))
    }
    
    private func updateView() {
        var hasCategories = false
        if let fetchedObjects = fetchedResultsController.fetchedObjects {
            hasCategories = fetchedObjects.count > 0
        }
        tableView.isHidden = !hasCategories
        messageLabel.isHidden = hasCategories
    }
    
    @objc private func add(sender: UIBarButtonItem) {
        performSegue(withIdentifier: Segue.AddCategory, sender: self)
    }
}

extension CategoriesViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch (type) {
        case .insert:
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
            }
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        case .update:
            if let indexPath = indexPath, let cell = tableView.cellForRow(at: indexPath) as? CategoryTableViewCell {
                configure(cell, at: indexPath)
            }
        case .move:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            
            if let newIndexPath = newIndexPath {
                tableView.insertRows(at: [newIndexPath], with: .fade)
            }
        }
    }
}

extension CategoriesViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let sections = fetchedResultsController.sections else { return 0 }
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = fetchedResultsController.sections?[section] else { return 0 }
        return section.numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CategoryTableViewCell.reuseIdentifier, for: indexPath) as? CategoryTableViewCell else {
            fatalError("unexpected index path")
        }
        configure(cell, at: indexPath)
        return cell
    }
    
    func configure(_ cell: CategoryTableViewCell, at indexPath: IndexPath) {
        let category = fetchedResultsController.object(at: indexPath)
        cell.nameLabel.text = category.name
        
        if note?.category == category {
            cell.nameLabel.textColor = .bitterSweet
        } else {
            cell.nameLabel.textColor = .black
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        let category = fetchedResultsController.object(at: indexPath)
        note?.managedObjectContext?.delete(category)
    }
}

extension CategoriesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        // fetch category
        let category = fetchedResultsController.object(at: indexPath)
        // update note
        note?.category = category
        
        // pop
        let _ = navigationController?.popViewController(animated: true)
    }
}

private enum Segue {
    static let AddCategory = "AddCategory"
    static let Category = "Category"
}
