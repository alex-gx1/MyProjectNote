import Foundation
import UIKit
import CoreData
import YandexMapsMobile

class MainViewModel {
    
    
    func fetchNotes() -> [Note]? {
           return StorageManager.shared.fetchNotes()
       }
    
    func numberOfSection() -> Int {
        return 1
    }
    func numberOfRows(_ section: Int) -> Int {
            if let notes = fetchNotes() {
                return notes.count
            } else {
                return 0
            }
        }
    
}
