//
//  ViewController.swift
//  Notes
//
//  Created by Woon on 27/02/2019.
//  Copyright © 2019 Woon. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    // MARK: - Properties
    private var coreDataManager = CoreDataManager(modelName: "Notes")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if let entityDesc = NSEntityDescription.entity(forEntityName: "Note", in: coreDataManager.managedObjectContext) {
            
            print(entityDesc.name ?? "No Name")
            print(entityDesc.properties)
            
            // init managed object
            let note = NSManagedObject(entity: entityDesc,
                                       insertInto: coreDataManager.managedObjectContext)
            
            // configure managed object
            note.setValue("My first note", forKey: "title")
            note.setValue(Date(), forKey: "createdAt")
            note.setValue(Date(), forKey: "updatedAt")
            
            print(note)
            
            do {
                try coreDataManager.managedObjectContext.save()
            } catch {
                print("Unable to Save Managed Object Context")
                print("\(error), \(error.localizedDescription)") 
            }
        }
    }


}

