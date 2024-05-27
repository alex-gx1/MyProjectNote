import Foundation
import CoreData
import UIKit

extension Notification.Name {
    static let notesDidChange = Notification.Name("notesDidChange")
}
public final class StorageManager: NSObject {
    public static let shared = StorageManager()
    private override init() {}
    
    private var appDelegate: AppDelegate {
        guard let delegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("Unable to access AppDelegate")
        }
        return delegate
    }
    private var context: NSManagedObjectContext {
        appDelegate.persistentContainer.viewContext
    }
    public func createNote(_ title: String?, noteDescription: String?, latitudeY: Double, longitudeX: Double) {
        guard let noteEntityDescription = NSEntityDescription.entity(forEntityName: "Note", in: context) else { return
        }
        let note = Note(entity: noteEntityDescription, insertInto: context)
        note.latitudeY = latitudeY
        note.longitudeX = longitudeX
        note.noteDescription = noteDescription
        note.title = title
        appDelegate.saveContext()
        NotificationCenter.default.post(name: .notesDidChange, object: nil)
    }
    public func fetchNotes() -> [Note]? {
        let fetchRequest = NSFetchRequest<Note>(entityName: "Note")
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Error fetching notes: \(error)")
            return nil
        }
    }
    public func fetchNote(with title: String?) -> Note? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Note")
        do {
            guard let notes = try? context.fetch(fetchRequest) as? [Note] else { return nil }
            return notes.first(where: { $0.title == title})
        }
    }
    public func deleteNote(with title: String?) {
        let fetchRequest = NSFetchRequest<Note>(entityName: "Note")
        
        do {
            let notes = try context.fetch(fetchRequest)
            if let title = title {
                if let note = notes.first(where: { $0.title == title }) {
                    context.delete(note)
                    
                    try context.save()
                    print("Note with title '\(title)' successfully deleted")
                } else {
                    print("Note with title '\(title)' not found")
                }
            } else {
                print("Error: No title provided")
            }
        } catch {
            print("Error deleting note: \(error)")
        }
        NotificationCenter.default.post(name: .notesDidChange, object: nil)
    }
    
    
}

