import Foundation
import UIKit
import YandexMapsMobile
import CoreData

class AddNote: UIViewController {
    
    var AddViewModel = AddNoteViewModel()
    var mapView: YMKMapView!
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func buttonChooseLocationTapped(_ sender: UIButton){
        mapView = YMKMapView(frame: view.bounds)
        view.addSubview(mapView)
        mapView.mapWindow.map.move(
            with: YMKCameraPosition(
                target: YMKPoint(latitude:  59.935493, longitude:  30.327392),
                zoom:  15, azimuth:  0, tilt:  0 ),
            animation: YMKAnimation(type: YMKAnimationType.smooth, duration:  5),
            cameraCallback: nil)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        mapView.addGestureRecognizer(tapGesture)
    }

    @IBAction func buttonSubbmitTapped(_ sender: UIButton) {
        let title = textField.text
        let description = textView.text
        AddViewModel.addNoteToBD(title: title, noteDescription: description, longitudeX: longitude, latitudeY: latitude)
        navigationController?.popViewController(animated: true)
    }
    
    @objc func handleTap(_ gestureRecognizer: UITapGestureRecognizer) {
        if gestureRecognizer.state == .ended {
            let locationInView = gestureRecognizer.location(in: mapView)
            let screenPoint = YMKScreenPoint(x: Float(Double(locationInView.x)), y: Float(Double(locationInView.y)))
            let worldPoint = mapView.mapWindow.screenToWorld(with: screenPoint)
            
            let alert = UIAlertController(title: "Подтверждение", message: "Вы выбрали точку с координатами \(String(describing: worldPoint?.latitude)), \(String(describing: worldPoint?.longitude)). Хотите продолжить?", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Да", style: .default, handler: { _ in
                        self.latitude = worldPoint?.latitude ?? 0.0
                        self.longitude = worldPoint?.longitude ?? 0.0
                        self.mapView.removeFromSuperview()
                    }))
            
                    alert.addAction(UIAlertAction(title: "Выбрать заново", style: .cancel, handler: { _ in
                        alert.dismiss(animated: true, completion: nil)
                    }))
            
                    present(alert, animated: true, completion: nil)
        }
    }
}
