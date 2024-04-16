import Foundation
import UIKit
import CoreData
import YandexMapsMobile

class YourNote: UIViewController {
    
    var yourNoteViewModel = YourNoteViewModel()
    var mapView: YMKMapView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    
    var selectedTitle: String?
    var selectedNote: Note?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedNote = yourNoteViewModel.fetchNote(with: selectedTitle)
        if let note = selectedNote {
            titleLabel.text = note.title
            textView.text = note.noteDescription
        }
    }
    
    private func addPlacemark(_ map: YMKMap) {
        if let selectedNote = selectedNote {
            let image = UIImage(named: "image") ?? UIImage()
            let placemark = map.mapObjects.addPlacemark(with: YMKPoint(latitude: selectedNote.latitudeY, longitude: selectedNote.longitudeX))
            placemark.geometry = YMKPoint(latitude: selectedNote.latitudeY, longitude: selectedNote.longitudeX)
            placemark.setIconWith(image)
        }
    }
    
    @IBAction func seeLocationTapped(_ sender: UIButton) {
        mapView = YMKMapView(frame: view.bounds)
        view.addSubview(mapView)
        if let selectedNote = selectedNote {
            mapView.mapWindow.map.move(
                with: YMKCameraPosition(
                    target: YMKPoint(latitude: selectedNote.latitudeY, longitude: selectedNote.longitudeX),
                    zoom:  15, azimuth:  0, tilt:  0 ),
                animation: YMKAnimation(type: YMKAnimationType.smooth, duration:  5),
                cameraCallback: nil)
            addPlacemark(mapView.mapWindow.map)
        }
    }
}
