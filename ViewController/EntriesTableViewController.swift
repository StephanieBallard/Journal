//
//  EntriesTableViewController.swift
//  Journal
//
//  Created by Stephanie Ballard on 8/11/20.
//  Copyright © 2020 Stephanie Ballard. All rights reserved.
//

import UIKit
import CoreData

class EntriesTableViewController: UITableViewController {
    
    let entryController = EntryController()
    
//    Create a fetch request from the Entry object.
//    Create a sort descriptor that will sort the entries based on their mood. This can be either ascending or descending depending on your preference.
//    Create a sort descriptor that will sort the entries based on their timestamp. This can also be either ascending or descending depending on your preference.
//    Give the sort descriptor to the fetch request's sortDescriptors property. Note that this property's type is an array of sort descriptors, not a single one.
//    Create a constant that references your core data stack's mainContext.
//    Create a constant and initialize an NSFetchedResultsController using the fetch request and managed object context. For the sectionNameKeyPath, put "mood" (exactly how you spelled it in the data model file), and nil for cacheName.
//    Set this view controller class as the delegate of the fetched results controller. NOTE: Xcode will give you an error, but you will fix it in just a second.
//    Perform the fetch request using the fetched results controller
//    Return the fetched results controller.

    lazy var fetchedResultsController: NSFetchedResultsController<Entry> = {
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "mood", ascending: true)]
        let context = CoreDataStack.shared.mainContext
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: "mood", cacheName: nil)
        frc.delegate = self
        do {
            try frc.performFetch()
        } catch {
            NSLog("Error performing initial fetch inside fetchedResultsController: \(error)")
        }
        return frc
    }()
    
//    var entries: [Entry] {
//        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
//        let context = CoreDataStack.shared.mainContext
//        do {
//            return try context.fetch(fetchRequest)
//        } catch {
//            NSLog("Error fetching entries: \(error)")
//            return []
//        }
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "EntryCell", for: indexPath) as? EntryTableViewCell else { return UITableViewCell() }

        // Configure the cell...

        cell.entry = fetchedResultsController.object(at: indexPath)
        
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let entry = fetchedResultsController.object(at: indexPath)
            let context = CoreDataStack.shared.mainContext
            context.delete(entry)
            do {
                try context.save()
                tableView.reloadData()
            } catch {
                context.reset()
                NSLog("Error saving managed object context (delete entry): \(error)")
            }
        }    
    }
    
    // MARK: - Navigation

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddEntrySegue" {
            if let navVC = segue.destination as? UINavigationController,
                let addEntryVC = navVC.viewControllers.first as? CreateEntryViewController {
                addEntryVC.entryController = entryController
            }
        }
        
        if segue.identifier == "EntryDetailsSegue" {
            if let entryDetailVC = segue.destination as? EntryDetailViewController,
                let indexPath = tableView.indexPathForSelectedRow {
                entryDetailVC.entry = fetchedResultsController.object(at: indexPath)
                entryDetailVC.entryController = entryController
            }
        }
    }
}

extension EntriesTableViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange sectionInfo: NSFetchedResultsSectionInfo,
                    atSectionIndex sectionIndex: Int,
                    for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            tableView.insertSections(IndexSet(integer: sectionIndex), with: .automatic)
        case .delete:
            tableView.deleteSections(IndexSet(integer: sectionIndex), with: .automatic)
        default:
            break
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            guard let newIndexPath = newIndexPath else { return }
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        case .update:
            guard let indexPath = indexPath else { return }
            tableView.reloadRows(at: [indexPath], with: .automatic)
        case .move:
            guard let oldIndexPath = indexPath,
                let newIndexPath = newIndexPath else { return }
            tableView.deleteRows(at: [oldIndexPath], with: .automatic)
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        case .delete:
            guard let indexPath = indexPath else { return }
            tableView.deleteRows(at: [indexPath], with: .automatic)
        @unknown default:
            break
        }
    }
}
