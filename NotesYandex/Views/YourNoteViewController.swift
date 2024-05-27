import Foundation
import UIKit
import YandexMapsMobile
import CoreData

class YourNoteViewController: UIViewController {
    
    var viewModel = YourNoteViewModel()
    var mapView: YMKMapView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    
    var selectedTitle: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.fetchNote(with: selectedTitle)
        updateUI()
    }
    
    private func updateUI() {
        let noteDetails = viewModel.getNoteDetails()
        titleLabel.text = noteDetails.title
        textView.text = noteDetails.description
    }
    
    private func addPlacemark(_ map: YMKMap) {
        guard let coordinates = viewModel.getNoteCoordinates() else { return }
        let image = UIImage(named: "image") ?? UIImage()
        let placemark = map.mapObjects.addPlacemark(with: YMKPoint(latitude: coordinates.latitude, longitude: coordinates.longitude))
        placemark.setIconWith(image)
    }
    
    @IBAction func seeLocationTapped(_ sender: UIButton) {
        mapView = YMKMapView(frame: view.bounds)
        view.addSubview(mapView)
        guard let coordinates = viewModel.getNoteCoordinates() else { return }
        mapView.mapWindow.map.move(
            with: YMKCameraPosition(
                target: YMKPoint(latitude: coordinates.latitude, longitude: coordinates.longitude),
                zoom: 15, azimuth: 0, tilt: 0),
            animation: YMKAnimation(type: .smooth, duration: 5),
            cameraCallback: nil)
        addPlacemark(mapView.mapWindow.map)
    }
}
