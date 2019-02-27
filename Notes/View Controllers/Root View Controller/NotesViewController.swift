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

    // MARK: - Properties
    private var coreDataManager = CoreDataManager(modelName: "Notes")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
//        if let entityDesc = NSEntityDescription.entity(forEntityName: "Note", in: coreDataManager.managedObjectContext) {
//            
//            print(entityDesc.name ?? "No Name")
//            print(entityDesc.properties)
//            
//            // init managed object
//            let note = NSManagedObject(entity: entityDesc,
//                                       insertInto: coreDataManager.managedObjectContext)
//            
//            // configure managed object
//            note.setValue("My first note", forKey: "title")
//            note.setValue(Date(), forKey: "createdAt")
//            note.setValue(Date(), forKey: "updatedAt")
//            
//            print(note)
//            
//            let foo = Note(context: coreDataManager.managedObjectContext)
//            foo.title = "my second note"
//            foo.createdAt = Date()
//            foo.updatedAt = Date()
//            
//            do {
//                try coreDataManager.managedObjectContext.save()
//            } catch {
//                print("Unable to Save Managed Object Context")
//                print("\(error), \(error.localizedDescription)") 
//            }
//        }
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

}

private enum Segue {
    
    static let AddNote = "AddNote"
    
}
