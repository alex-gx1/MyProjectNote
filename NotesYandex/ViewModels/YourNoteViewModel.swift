import Foundation
import CoreData
import UIKit
import YandexMapsMobile

class YourNoteViewModel {
    var selectedTitle: String?
    
    func fetchNote(with title: String?) -> Note? {
            return StorageManager.shared.fetchNote(with: title)
        }
}
