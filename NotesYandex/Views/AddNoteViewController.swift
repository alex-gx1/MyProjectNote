import Foundation
import UIKit
import YandexMapsMobile
import CoreData
class AddNoteViewController: UIViewController {
    
    var viewModel: AddNoteViewModel!
    var mapView: YMKMapView!
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func buttonChooseLocationTapped(_ sender: UIButton) {
        setupMapView()
    }
    
    private func setupMapView() {
        mapView = YMKMapView(frame: view.bounds)
        view.addSubview(mapView)
        mapView.mapWindow.map.move(
            with: YMKCameraPosition(
                target: YMKPoint(latitude: 59.935493, longitude: 30.327392),
                zoom: 15, azimuth: 0, tilt: 0),
            animation: YMKAnimation(type: .smooth, duration: 5),
            cameraCallback: nil)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        mapView.addGestureRecognizer(tapGesture)
    }
    
    @IBAction func buttonSubmitTapped(_ sender: UIButton) {
        let title = textField.text
        let description = textView.text
        viewModel.addNote(title: title, description: description)
        navigationController?.popViewController(animated: true)
    }
    
    @objc func handleTap(_ gestureRecognizer: UITapGestureRecognizer) {
        if gestureRecognizer.state == .ended {
            let locationInView = gestureRecognizer.location(in: mapView)
            let screenPoint = YMKScreenPoint(x: Float(locationInView.x), y: Float(locationInView.y))
            let worldPoint = mapView.mapWindow.screenToWorld(with: screenPoint)
            
            let latitude = worldPoint?.latitude ?? 0.0
            let longitude = worldPoint?.longitude ?? 0.0
            
            let alert = UIAlertController(title: "Подтверждение", message: "Вы выбрали точку с координатами \(latitude), \(longitude). Хотите продолжить?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Да", style: .default, handler: { [weak self] _ in
                self?.viewModel.setCoordinates(latitude: latitude, longitude: longitude)
                self?.mapView.removeFromSuperview()
            }))
            alert.addAction(UIAlertAction(title: "Выбрать заново", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
}
