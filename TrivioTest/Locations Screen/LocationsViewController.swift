//
//  LocationsViewController.swift
//  TrivioTest
//
//  Created by Anvar Bagautdinov on 27.05.2023.
//

import UIKit

class LocationsViewController: UIViewController, Coordinating {

    //MARK: - Properties

    private struct Constants {
        static let panelViewHeight: CGFloat = 135
        static let topOffset: CGFloat = 10
    }

    var coordinator: CoordinatorProtocol?

    private var firstPanelView = PanelView()
    private var secondPanelView = PanelView()
    private var thirdPanelView = PanelView()
    private var fourthPanelView = PanelView()
    private var fifthPanelView = PanelView()
    private var tempC = Double()
    private var tempF = Double()
    private var tempK = Double()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        navigationController?.navigationBar.barTintColor = .black
        setUpConstraints()
        setUpPanels()
    }

    //MARK: - Methods

    private func setUpPanels() {
        let panelsArray = [firstPanelView, secondPanelView, thirdPanelView, fourthPanelView, fifthPanelView]
        panelsArray.forEach { panel in
            let lat = Double.random(in: (-90...90)).rounded(toPlaces: 5)
            let lon = Double.random(in: (-180...180)).rounded(toPlaces: 5)

            panel.changeLabelText(text: "Lat: \(String(format: "%.3f", lat));", UIElement: panel.latLabel)
            panel.changeLabelText(text: "Lon: \(String(format: "%.3f", lon));", UIElement: panel.lonLabel)

            CityManager.getCityNameFromCoordinates(latitude: lat, longitude: lon) { name in
                DispatchQueue.main.async {
                    panel.changeLabelText(text: "City: \(name);", UIElement: panel.cityLabel)
                }
            }

            NetworkManager.fetch(lat: lat, lon: lon) { [weak self] temp in
                guard let self else { return }

                DispatchQueue.main.async {
                    self.tempK = temp
                    self.tempC = self.convertTemperature(tempInKelvin: self.tempK, celsius: true)
                    panel.changeLabelText(text: "Temperature: \(String(format: "%.2f", self.tempC))", UIElement: panel.tempLabel)

                }
            }

            panel.segmentedControlCallback = { control in
                self.segmentedControlChanged(control, lat: lat, lon: lon, panelView: panel)
            }

        }
    }

    private func segmentedControlChanged(
        _ segmentedControl: UISegmentedControl,
        lat: Double,
        lon: Double,
        panelView: PanelView
    ) {
        NetworkManager.fetch(lat: lat, lon: lon) { [weak self] temp in
            guard let self else { return }
            DispatchQueue.main.async {
                self.tempK = temp
                self.tempC = self.convertTemperature(tempInKelvin: self.tempK, celsius: true)
                self.tempF = self.convertTemperature(tempInKelvin: self.tempK, celsius: false)

                switch segmentedControl.selectedSegmentIndex {
                case 0:
                    panelView.changeLabelText(text: "Temperature: \(String(format: "%.2f", self.tempC))", UIElement: panelView.tempLabel)
                case 1:
                    panelView.changeLabelText(text: "Temperature: \(String(format: "%.2f", self.tempF))", UIElement: panelView.tempLabel)
                default:
                    return
                }
            }
        }
    }

    private func convertTemperature(tempInKelvin temperature: Double, celsius: Bool) -> Double {
        return celsius ? (temperature - 273.15) : (1.8 * (temperature - 273) + 32)
    }

    private func setUpConstraints() {
        view.addSubviews(firstPanelView, secondPanelView, thirdPanelView, fourthPanelView, fifthPanelView)

        NSLayoutConstraint.activate([

            firstPanelView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: Constants.topOffset),
            firstPanelView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            firstPanelView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            firstPanelView.heightAnchor.constraint(equalToConstant: Constants.panelViewHeight),

            secondPanelView.topAnchor.constraint(equalTo: firstPanelView.bottomAnchor, constant: Constants.topOffset),
            secondPanelView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            secondPanelView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            secondPanelView.heightAnchor.constraint(equalToConstant: Constants.panelViewHeight),

            thirdPanelView.topAnchor.constraint(equalTo: secondPanelView.bottomAnchor, constant: Constants.topOffset),
            thirdPanelView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            thirdPanelView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            thirdPanelView.heightAnchor.constraint(equalToConstant: Constants.panelViewHeight),

            fourthPanelView.topAnchor.constraint(equalTo: thirdPanelView.bottomAnchor, constant: Constants.topOffset),
            fourthPanelView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            fourthPanelView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            fourthPanelView.heightAnchor.constraint(equalToConstant: Constants.panelViewHeight),

            fifthPanelView.topAnchor.constraint(equalTo: fourthPanelView.bottomAnchor, constant: Constants.topOffset),
            fifthPanelView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            fifthPanelView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            fifthPanelView.heightAnchor.constraint(equalToConstant: Constants.panelViewHeight)
        ])
    }

}
