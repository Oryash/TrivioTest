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

    //TODO: вынести в константы все значения
    //TODO: вынести в стринг файл все стринги
    private struct Constants {
        static let panelViewHeight: CGFloat = 135
    }
    var coordinator: CoordinatorProtocol?

    let locationManager = CLLocationManager()
    let regionInMeters: Double = 10000
    var isPanelShown = false

    var lat = Double()
    private lazy var latLabel: UILabel = {
        var label = UILabel()
        label.backgroundColor = .white
        label.textColor = .black
        label.text = "Lat: ;"
        label.font = label.font.withSize(20)
        return label
    }()

    var lon = Double()
    private lazy var lonLabel: UILabel = {
        var label = UILabel()
        label.backgroundColor = .white
        label.textColor = .black
        label.text = "Lon: ;"
        label.font = label.font.withSize(20)

        return label
    }()

    var city = String()
    private lazy var cityLabel: UILabel = {
        var label = UILabel()
        label.backgroundColor = .white
        label.textColor = .black
        label.text = "City: "
        label.font = label.font.withSize(20)

        return label
    }()

    var tempC = Double()
    var tempF = Double()
    var tempK = Double()
    private lazy var tempLabel: UILabel = {
        var label = UILabel()
        label.backgroundColor = .white
        label.textColor = .black
        label.text = "Temperature: "
        label.font = label.font.withSize(20)

        return label
    }()

    private lazy var segmentedControl: UISegmentedControl = {
        var mySwitch = UISegmentedControl()
        return mySwitch
    }()

    var panelViewBottomConstraint: NSLayoutConstraint?

    private lazy var mapView: MKMapView = {
        let map = MKMapView()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        map.addGestureRecognizer(tapGesture)
        return map
    }()

    private lazy var panelView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
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

    func getCityNameFromCoordinates(latitude: CLLocationDegrees, longitude: CLLocationDegrees, completion: @escaping (String) -> ()) {
        let location = CLLocation(latitude: latitude, longitude: longitude)

        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
            guard let placemark = placemarks?.first, error == nil else {
                print("Reverse geocoding failed: \(error?.localizedDescription ?? "Unknown Error")")
                return
            }

            //TODO: city name переменная вообще используется где-либо?
            if let cityName = placemark.locality {
                self.city = cityName
                completion(cityName)
            } else {
                self.city = "Нет города поблизости"
                completion("Нет города поблизости")
            }
        }
    }

    private func convertTemperature(_ temperature: Double, celsius: Bool) -> Double {

        if celsius {
            return temperature - 273.15
        } else {
            return 1.8 * (temperature - 273) + 32
        }

    }

    func setMapConstraints() {
        view.addSubviews(mapView, panelView)
        panelView.addSubviews(latLabel, lonLabel, cityLabel, tempLabel, segmentedControl)
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: self.view.topAnchor),
            mapView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            mapView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),

            panelView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: Constants.panelViewHeight),
            panelView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            panelView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            panelView.heightAnchor.constraint(equalToConstant: Constants.panelViewHeight),

            latLabel.topAnchor.constraint(equalTo: panelView.topAnchor, constant: 15),
            latLabel.leadingAnchor.constraint(equalTo: panelView.leadingAnchor, constant: 20),

            lonLabel.topAnchor.constraint(equalTo: panelView.topAnchor, constant: 15),
            lonLabel.leadingAnchor.constraint(equalTo: latLabel.trailingAnchor, constant: 5),

            cityLabel.topAnchor.constraint(equalTo: latLabel.bottomAnchor, constant: 10),
            cityLabel.leadingAnchor.constraint(equalTo: panelView.leadingAnchor, constant: 20),

            tempLabel.topAnchor.constraint(equalTo: cityLabel.bottomAnchor, constant: 10),
            tempLabel.leadingAnchor.constraint(equalTo: panelView.leadingAnchor, constant: 20),

            segmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            segmentedControl.bottomAnchor.constraint(equalTo: tempLabel.bottomAnchor)

        ])
    }

    @objc func handleTap(_ gestureRecognizer: UITapGestureRecognizer) {
        if isPanelShown == false {
            let tapPoint = gestureRecognizer.location(in: mapView)
            let tapCoordinate = mapView.convert(tapPoint, toCoordinateFrom: mapView)

            let annotation = MKPointAnnotation()
            annotation.coordinate = tapCoordinate
            annotation.title = "Hello"
            mapView.addAnnotation(annotation)

            let center = CLLocationCoordinate2D(latitude: annotation.coordinate.latitude, longitude: annotation.coordinate.longitude)
            let region = MKCoordinateRegion.init(center: center, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
            mapView.setRegion(region, animated: true)

            lat = annotation.coordinate.latitude
            lon = annotation.coordinate.longitude
            latLabel.text = "Lat: \(String(format: "%.3f", lat));"
            lonLabel.text = "Lon: \(String(format: "%.3f", lon));"
            //TODO: пока город грузится, сделать loader 
            getCityNameFromCoordinates(latitude: lat, longitude: lon) { name in
                self.cityLabel.text = "City: \(name);"
            }

            //TODO: точно ли нам нужны все эти переменные типа lat lon и city temp, когда их можно сделать локальными?
            NetworkManager.fetch(lat: lat, lon: lon) { [weak self] temp in
                guard let self else { return }
                DispatchQueue.main.async {
                    self.tempK = temp
                    self.tempC = self.convertTemperature(self.tempK, celsius: true)
                    self.tempLabel.text = "Temperature: \(String(format: "%.2f", self.tempC))"

                }
            }

            UIView.animate(withDuration: 0.5) {
                self.panelViewBottomConstraint?.isActive = false
                self.panelViewBottomConstraint = self.panelView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0)
                self.panelViewBottomConstraint?.isActive = true
                self.view.layoutIfNeeded()
            }
            isPanelShown = true
        } else if isPanelShown {
                UIView.animate(withDuration: 0.5) {
                    self.panelViewBottomConstraint?.isActive = false
                    self.panelViewBottomConstraint = self.panelView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: Constants.panelViewHeight)
                    self.panelViewBottomConstraint?.isActive = true
                    self.view.layoutIfNeeded()

                }
                self.isPanelShown = false

        }
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
        let size = CGSize(width: 30, height: 30)
        let scaledImage = image?.scaleToSize(size)
        annotationView?.image = scaledImage
        annotationView?.centerOffset = CGPoint(x: 0, y: -15)

        return annotationView
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
