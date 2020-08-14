//
//  EntryDetailViewController.swift
//  Journal
//
//  Created by Stephanie Ballard on 8/12/20.
//  Copyright © 2020 Stephanie Ballard. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {

    var entryController: EntryController?
    var entry: Entry?
    var wasEdited: Bool = false
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var moodSegmentedControl: UISegmentedControl!
    @IBOutlet weak var bodyTextTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = editButtonItem
        updateViews()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        guard let entry = entry,
            let bodyText = bodyTextTextView.text,
            !bodyText.isEmpty,
        
            let entryTitle = titleTextField.text,
            !entryTitle.isEmpty else { return }
        
        let entryMood = Mood.allCases[moodSegmentedControl.selectedSegmentIndex].rawValue
        
        if wasEdited {
            entry.bodyText = bodyText
            entry.title = entryTitle
            entry.mood = entryMood
        }
        do {
            try CoreDataStack.shared.mainContext.save()
        } catch {
            print("Error saving edited Entry: \(error)")
        }
    }
    
    private func updateViews() {
        guard let entry = entry else { return }
        
        guard let entryMood = entry.mood,
            let mood = Mood(rawValue: entryMood),
            let moodIndex = Mood.allCases.firstIndex(of: mood) else { return }
        
        titleTextField.text = entry.title
        moodSegmentedControl.selectedSegmentIndex = moodIndex
        bodyTextTextView.text = entry.bodyText
        
        titleTextField.isUserInteractionEnabled = isEditing
        bodyTextTextView.isUserInteractionEnabled = isEditing
        moodSegmentedControl.isUserInteractionEnabled = isEditing
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        if editing { wasEdited = true }
        
        titleTextField.isUserInteractionEnabled = editing
        bodyTextTextView.isUserInteractionEnabled = editing
        moodSegmentedControl.isUserInteractionEnabled = editing
        
        navigationItem.hidesBackButton = editing
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
