//
//  ViewController.swift
//  Notes
//
//  Created by Woon on 27/02/2019.
//  Copyright © 2019 Woon. All rights reserved.
//

import UIKit
import CoreData

class NotesViewController: UIViewController {

    @IBOutlet var notesView: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    
    private var coreDataManager = CoreDataManager(modelName: "Notes")
    private let estimatedRowHeight = CGFloat(44.0)
    private var notes: [Note]? {
        didSet {
            updateView()
        }
    }
    private var hasNotes: Bool {
        guard let notes = notes else { return false }
        return notes.count > 0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        title = "Notes"
        setupView()
        fetchNotes()
       
    }

    private func fetchNotes() {
        // create fetch request
        let fetchRequest: NSFetchRequest<Note> = Note.fetchRequest()
        // configure it
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: #keyPath(Note.updatedAt),
                                                         ascending: false)]
        // perform fetch request
        coreDataManager.managedObjectContext.performAndWait {
            do {
                // execute fetch request
                let notes = try fetchRequest.execute()
                // update notes
                self.notes = notes
                self.tableView.reloadData()
            } catch {
                let fetchError = error as NSError
                print("Unable to Execute Fetch Request")
                print("\(fetchError), \(fetchError.localizedDescription)")
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        
        switch identifier {
        case Segue.AddNote:
            guard let destination = segue.destination as? AddNoteViewController else { return }
            
            // configure destination
            destination.managedObjectContext = coreDataManager.managedObjectContext
        default:
            break
            
        }
    }

    // MARK: - View Methods
    
    private func setupView() {
        setupMessageLabel()
        setupTableView()
    }
    
    private func updateView() {
        tableView.isHidden = !hasNotes
        messageLabel.isHidden = hasNotes
    }
    
    // MARK: -
    
    private func setupMessageLabel() {
        messageLabel.text = "You don't have any notes yet."
    }
    
    // MARK: -
    
    private func setupTableView() {
        tableView.isHidden = true
        tableView.estimatedRowHeight = estimatedRowHeight
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    private lazy var updatedAtDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, HH:mm"
        return dateFormatter
    }()
}

extension NotesViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return hasNotes ? 1 : 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let notes = notes else { return 0 }
        return notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let note = notes?[indexPath.row] else {
            fatalError("Unexpected index path")
        }
        // Dequeue Reusable Cell
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NoteTableViewCell.reuseIdentifier, for: indexPath) as? NoteTableViewCell else {
            fatalError("Unexpected Index Path")
        }
        // configure cell
        cell.titleLabel.text = note.title
        cell.contentsLabel.text = note.contents
        cell.updatedAtLabel.text = updatedAtDateFormatter.string(from: note.updatedAtAsDate)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
    }
    
}

private enum Segue {
    
    static let AddNote = "AddNote"
    
}
