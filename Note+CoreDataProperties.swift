//
//  Note+CoreDataProperties.swift
//  NotesYandex
//
//  Created by Алексей Кононенко on 14.04.24.
//
//

import Foundation
import CoreData


extension Note {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Note> {
        return NSFetchRequest<Note>(entityName: "Note")
    }

    @NSManaged public var latitudeY: Double
    @NSManaged public var longitudeX: Double
    @NSManaged public var noteDescription: String?
    @NSManaged public var title: String?

}

extension Note : Identifiable {

}
