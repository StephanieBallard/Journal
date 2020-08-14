//
//  EntryRepresentation.swift
//  Journal
//
//  Created by Stephanie Ballard on 8/13/20.
//  Copyright © 2020 Stephanie Ballard. All rights reserved.
//

import Foundation
import CoreData

struct EntryRepresentation: Codable {
    var bodyText: String
    var identifier: String
    var mood: String
    var timestamp: Date
    var title: String
}
