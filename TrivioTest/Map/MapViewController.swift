//
//  MapViewController.swift
//  TrivioTest
//
//  Created by Anvar Bagautdinov on 24.05.2023.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, Coordinating {
    var coordinator: CoordinatorProtocol?

    let locationManager = CLLocationManager()
    let regionInMeters: Double = 10000

    private lazy var mapView: MKMapView = {
        let map = MKMapView()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        map.addGestureRecognizer(tapGesture)
        return map
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        title = "Карта"
        setMapConstraints()
        checkLocationServices()
        mapView.delegate = self

    }

    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }

    func centerViewOnUserLocation() {
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
            mapView.setRegion(region, animated: true)
        }
    }

    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() { //TODO: This method can cause UI unresponsiveness if invoked on the main thread. Instead, consider waiting for the `-locationManagerDidChangeAuthorization:` callback and checking `authorizationStatus` first.
            setupLocationManager()
            checkLocationAuthorization()
        } else {
            //TODO: show alert letting the user know they have to turn this on
        }
    }

    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            mapView.showsUserLocation = true
            centerViewOnUserLocation()
            locationManager.startUpdatingLocation()
            break
        case .denied:
            //TODO: show alert instructing them how to turn on permissions
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            break
        case .restricted:
            // TODO: Show an alert letting them know what's up
            break
        case .authorizedAlways:
            break
        }
    }

    func setMapConstraints() {
        view.addSubviews(mapView)
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: self.view.topAnchor),
            mapView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            mapView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)


        ])
    }

    @objc func handleTap(_ gestureRecognizer: UITapGestureRecognizer) {

        let tapPoint = gestureRecognizer.location(in: mapView)
        let tapCoordinate = mapView.convert(tapPoint, toCoordinateFrom: mapView)

        let annotation = MKPointAnnotation()
        annotation.coordinate = tapCoordinate
        annotation.title = "Hello"
        mapView.addAnnotation(annotation)

        let center = CLLocationCoordinate2D(latitude: annotation.coordinate.latitude, longitude: annotation.coordinate.longitude)
        let region = MKCoordinateRegion.init(center: center, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
        mapView.setRegion(region, animated: true)
    }


}


extension MapViewController: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation { return nil }

        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "custom")

        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "custom")
        } else {
            annotationView?.annotation = annotation
        }

        let image = UIImage(named: "Pin")?.withRenderingMode(.alwaysOriginal)
        let size = CGSize(width: 30, height: 30) // Adjust the size as per your requirement
        let scaledImage = image?.scaleToSize(size)
        annotationView?.image = scaledImage
        annotationView?.centerOffset = CGPoint(x: 0, y: -15)

        return annotationView
    }

}

extension UIImage { //TODO: вынести в отдельный файл
    func scaleToSize(_ size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        defer { UIGraphicsEndImageContext() }
        self.draw(in: CGRect(origin: .zero, size: size))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //        guard let location = locations.last else { return }
        //        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        //        let region = MKCoordinateRegion.init(center: center, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
        //        mapView.setRegion(region, animated: true)
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }

}
