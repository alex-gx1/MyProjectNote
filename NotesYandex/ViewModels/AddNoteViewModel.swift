import Foundation
import UIKit
import CoreData
import YandexMapsMobile

class AddNoteViewModel {

    func addNoteToBD(title: String?, noteDescription: String?, longitudeX: Double, latitudeY: Double ) {
        StorageManager.shared.createNote(title, noteDescription: noteDescription, latitudeY: latitudeY, longitudeX: longitudeX)
    }
    
    func fetchNotes() -> [Note]? {
           return StorageManager.shared.fetchNotes()
       }
    
    func fetchNote(with title: String?) -> Note? {
            return StorageManager.shared.fetchNote(with: title)
        }
    
    func deleteNote(with title: String?) {
           guard let title = title else {
               print("Error: No title provided")
               return
           }
           StorageManager.shared.deleteNote(with: title)
       }
}
