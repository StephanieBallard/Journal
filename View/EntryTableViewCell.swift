//
//  EntryTableViewCell.swift
//  Journal
//
//  Created by Stephanie Ballard on 8/11/20.
//  Copyright © 2020 Stephanie Ballard. All rights reserved.
//

import UIKit

class EntryTableViewCell: UITableViewCell {

    @IBOutlet weak var titleTextLabel: UILabel!
    @IBOutlet weak var timestampTextLabel: UILabel!
    @IBOutlet weak var bodyTextTextLabel: UILabel!
    
    let dateFormatter: DateFormatter = {
        var formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()
    
    var entry: Entry? {
        didSet {
            updateViews()
        }
    }

    private func updateViews() {
        guard let entry = entry,
            let timestamp = entry.timestamp else { return }
        
        titleTextLabel.text = entry.title
        bodyTextTextLabel.text = entry.bodyText
        
        let entryTimestamp = dateFormatter.string(from: timestamp)
        timestampTextLabel.text = entryTimestamp
    }

}
