
import Foundation
import CoreData
import YandexMapsMobile

class YourNoteViewModel {
    private var selectedNote: Note?

    func fetchNote(with title: String?) {
        selectedNote = StorageManager.shared.fetchNote(with: title)
    }
    
    func getNoteDetails() -> (title: String?, description: String?) {
        return (selectedNote?.title, selectedNote?.noteDescription)
    }
    
    func getNoteCoordinates() -> (latitude: Double, longitude: Double)? {
        guard let note = selectedNote else { return nil }
        return (note.latitudeY, note.longitudeX)
    }
}
