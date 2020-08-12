//
//  Entry+Convenience.swift
//  Journal
//
//  Created by Stephanie Ballard on 8/11/20.
//  Copyright © 2020 Stephanie Ballard. All rights reserved.
//

import Foundation
import CoreData

enum Mood: String, CaseIterable {
    case happy = "☀️"
    case neutral = "⛅️"
    case sad = "🌧"
}

extension Entry {
    @discardableResult convenience init(identifier: UUID = UUID(),
                                        title: String,
                                        bodyText: String,
                                        timestamp: Date = Date(),
                                        mood: String = Mood.neutral.rawValue,
                                        context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.identifier = identifier
        self.title = title
        self.bodyText = bodyText
        self.timestamp = timestamp
        self.mood = mood
    }
}
