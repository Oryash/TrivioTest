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

    //MARK: - Properties

    private struct Constants {
        static let panelViewHeight: CGFloat = 135
        static let regionScale: Double = 10000
        static let barButtonOffset: CGFloat = 15
        static let barButtonInset: CGFloat = 30
    }

    var coordinator: CoordinatorProtocol?
    var alertManager: AlertManager = AlertManager()

    private let locationManager = CLLocationManager()
    private var isPanelShown = false
    private var lat = Double()
    private var lon = Double()
    private var tempC = Double()
    private var tempF = Double()
    private var tempK = Double()
    private var panelView = PanelView()
    private var panelViewBottomConstraint: NSLayoutConstraint?

    private lazy var mapView: MKMapView = {
        let map = MKMapView()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        map.addGestureRecognizer(tapGesture)
        return map
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setMapConstraints()
        checkLocationServices()
        mapView.delegate = self
        listenForSegmentedControl()
        setupBarButton()
        title = Strings.map.getString()

    }

    //MARK: - Methods

    private func listenForSegmentedControl() {
        panelView.segmentedControlCallback = { control in
            self.segmentedControlChanged(control)
        }
    }

    private func setupBarButton() {
        if let buttonImage = UIImage(named: Strings.buttonImageName.getString())?.withRenderingMode(.alwaysOriginal) {
            let barButtonItem = UIBarButtonItem(image: buttonImage, style: .plain, target: self, action: #selector(navigate))
            barButtonItem.imageInsets = UIEdgeInsets(top: 0, left: Constants.barButtonInset, bottom: 0, right: -Constants.barButtonInset)
            navigationItem.rightBarButtonItem = barButtonItem
        }
    }

    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }

    private func centerViewOnUserLocation() {
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: Constants.regionScale, longitudinalMeters: Constants.regionScale)
            mapView.setRegion(region, animated: true)
        }
    }

    private func checkLocationServices() {
        DispatchQueue.global().async {
            if CLLocationManager.locationServicesEnabled() {
                DispatchQueue.main.async {
                    self.setupLocationManager()
                    self.checkLocationAuthorization()
                }
            } else {
                DispatchQueue.main.async {
                    let action = UIAlertAction(title: "OK", style: .default) { _ in }
                    self.alertManager.showAlert(
                        with: .init(title: Strings.locationServicesTitle.getString(),
                                    message: Strings.locationServicesMessage.getString(),
                                    actions: [action]
                                   ),
                        on: self)
                }
            }
        }
    }

    private func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            mapView.showsUserLocation = true
            centerViewOnUserLocation()
            locationManager.startUpdatingLocation()
        case .denied:
            let action = UIAlertAction(title: "OK", style: .default) { _ in }
            alertManager.showAlert(with: .init(title: Strings.permissionTitle.getString(), message: Strings.permissionMessage.getString(), actions: [action]), on: self)
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            let action = UIAlertAction(title: "OK", style: .default) { _ in }
            alertManager.showAlert(with: .init(title: Strings.permissionTitle.getString(), message: Strings.permissionMessage.getString(), actions: [action]), on: self)
        case .authorizedAlways:
            mapView.showsUserLocation = true
            centerViewOnUserLocation()
            locationManager.startUpdatingLocation()
        @unknown default:
            break
        }
    }

    private func convertTemperature(tempInKelvin temperature: Double, celsius: Bool) -> Double {
        return celsius ? (temperature - 273.15) : (1.8 * (temperature - 273) + 32)
    }

    private func segmentedControlChanged(_ segmentedControl: UISegmentedControl) {
        NetworkManager.fetch(lat: lat, lon: lon) { [weak self] temp in
            guard let self else { return }
            DispatchQueue.main.async {
                self.tempK = temp
                self.tempC = self.convertTemperature(tempInKelvin: self.tempK, celsius: true)
                self.tempF = self.convertTemperature(tempInKelvin: self.tempK, celsius: false)

                switch segmentedControl.selectedSegmentIndex {
                case 0:
                    let newString = Strings.temperature.getString() + String(format: "%.2f", self.tempC)
                    self.panelView.changeLabelText(text: newString, UIElement: self.panelView.tempLabel)
                case 1:
                    let newString = Strings.temperature.getString() + String(format: "%.2f", self.tempF)
                    self.panelView.changeLabelText(text: newString, UIElement: self.panelView.tempLabel)
                default:
                    return
                }
            }
        }
    }

    private func hideShowPanel(constant: CGFloat) {
        UIView.animate(withDuration: 0.5) {
            self.panelViewBottomConstraint?.isActive = false
            self.panelViewBottomConstraint = self.panelView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: constant)
            self.panelViewBottomConstraint?.isActive = true
            self.view.layoutIfNeeded()
        }
    }


    private func setMapConstraints() {
        view.addSubviews(mapView, panelView)

        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: self.view.topAnchor),
            mapView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            mapView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),

            panelView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: Constants.panelViewHeight),
            panelView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            panelView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            panelView.heightAnchor.constraint(equalToConstant: Constants.panelViewHeight)
        ])
    }

    //MARK: - objc Methods

    @objc func handleTap(_ gestureRecognizer: UITapGestureRecognizer) {
        if !isPanelShown {
            let tapPoint = gestureRecognizer.location(in: mapView)
            let tapCoordinate = mapView.convert(tapPoint, toCoordinateFrom: mapView)

            let annotation = MKPointAnnotation()
            annotation.coordinate = tapCoordinate
            mapView.addAnnotation(annotation)

            let center = CLLocationCoordinate2D(latitude: annotation.coordinate.latitude, longitude: annotation.coordinate.longitude)
            let region = MKCoordinateRegion.init(center: center, latitudinalMeters: Constants.regionScale, longitudinalMeters: Constants.regionScale)
            mapView.setRegion(region, animated: true)

            lat = annotation.coordinate.latitude
            lon = annotation.coordinate.longitude

            panelView.changeLabelText(text: "Lat: \(String(format: "%.3f", lat));", UIElement: panelView.latLabel)
            panelView.changeLabelText(text: "Lon: \(String(format: "%.3f", lon));", UIElement: panelView.lonLabel)

            CityManager.getCityNameFromCoordinates(latitude: lat, longitude: lon) { name in
                DispatchQueue.main.async {
                    self.panelView.changeLabelText(text: "City: \(name);", UIElement: self.panelView.cityLabel)
                }
            }

            NetworkManager.fetch(lat: lat, lon: lon) { [weak self] temp in
                guard let self else { return }

                DispatchQueue.main.async {
                    self.tempK = temp
                    self.tempC = self.convertTemperature(tempInKelvin: self.tempK, celsius: true)
                    let newString = Strings.temperature.getString() + String(format: "%.2f", self.tempC)
                    self.panelView.changeLabelText(text: newString, UIElement: self.panelView.tempLabel)
                }
            }
            hideShowPanel(constant: 0)
            isPanelShown = true
        } else if isPanelShown {
            hideShowPanel(constant: Constants.panelViewHeight)
            isPanelShown = false
        }
    }

    @objc func navigate() {
        coordinator?.eventOccurred(with: .buttonPressed)
    }
}

//MARK: - MKMapViewDelegate

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation { return nil }

        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "custom")

        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "custom")
        } else {
            annotationView?.annotation = annotation
        }

        let image = UIImage(named: Strings.pinImageName.getString())?.withRenderingMode(.alwaysOriginal)
        let size = CGSize(width: Constants.barButtonInset, height: Constants.barButtonInset)
        let scaledImage = image?.scaleToSize(size)
        annotationView?.image = scaledImage
        annotationView?.centerOffset = CGPoint(x: 0, y: -Constants.barButtonOffset)

        return annotationView
    }

}

//MARK: - CLLocationManagerDelegate

extension MapViewController: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
}
