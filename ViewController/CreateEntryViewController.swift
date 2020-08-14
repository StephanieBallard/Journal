//
//  CreateEntryViewController.swift
//  Journal
//
//  Created by Stephanie Ballard on 8/11/20.
//  Copyright © 2020 Stephanie Ballard. All rights reserved.
//

import UIKit

class CreateEntryViewController: UIViewController {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var bodyTextTextView: UITextView!
    @IBOutlet weak var moodSegmentedControl: UISegmentedControl!
    
    var entryController: EntryController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleTextField.becomeFirstResponder()
    }

    @IBAction func cancelButtonTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        guard let entryTitle = titleTextField.text,
            let bodyText = bodyTextTextView.text,
            !entryTitle.isEmpty,
            !bodyText.isEmpty else { return }
        
        let moodIndex = moodSegmentedControl.selectedSegmentIndex
        let mood = Mood.allCases[moodIndex]
        
        let newEntry = Entry(title: entryTitle, bodyText: bodyText, mood: mood.rawValue)
        print(newEntry)
        do {
            try CoreDataStack.shared.mainContext.save()
            navigationController?.dismiss(animated: true, completion: nil)
        } catch {
            NSLog("Error saving managed object context: \(error)")
        }
        entryController?.sendEntryToServer(entry: newEntry)
    }
    
}

