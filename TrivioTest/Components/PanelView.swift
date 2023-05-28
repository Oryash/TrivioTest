//
//  self.swift
//  TrivioTest
//
//  Created by Anvar Bagautdinov on 27.05.2023.
//

import UIKit

class PanelView: UIView {

    //TODO: все свойства сделать снова приватными, затем вытащить методы на их изменение, через диспатчГруп

     lazy var latLabel: UILabel = {
        var label = UILabel()
        label.backgroundColor = .white
        label.textColor = .black
        label.text = "Lat: ;"
        label.font = label.font.withSize(20)
        return label
    }()

     lazy var lonLabel: UILabel = {
        var label = UILabel()
        label.backgroundColor = .white
        label.textColor = .black
        label.text = "Lon: ;"
        label.font = label.font.withSize(20)

        return label
    }()

     lazy var cityLabel: UILabel = {
        var label = UILabel()
        label.backgroundColor = .white
        label.textColor = .black
        label.text = "City: "
        label.font = label.font.withSize(20)

        return label
    }()


     lazy var tempLabel: UILabel = {
        var label = UILabel()
        label.backgroundColor = .white
        label.textColor = .black
        label.text = "Temperature: "
        label.font = label.font.withSize(20)

        return label
    }()

     lazy var segmentedControl: UISegmentedControl = {
        let items = ["C", "F"]
        var segment = UISegmentedControl(items: items)
        segment.selectedSegmentIndex = 0
        segment.addTarget(self, action: #selector(segmentedControlChanged), for: .valueChanged)
        return segment
    }()

    var segmentedControlCallback: (UISegmentedControl) -> () = { _ in }


    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        backgroundColor = .white
        layer.borderWidth = 0.5

        setConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func segmentedControlChanged(_ segmentedControl: UISegmentedControl) {
        segmentedControlCallback(segmentedControl)
    }

    private func setConstraints() {
        self.addSubviews(latLabel, lonLabel, cityLabel, tempLabel, segmentedControl)

        NSLayoutConstraint.activate([

            latLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 15),
            latLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),

            lonLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 15),
            lonLabel.leadingAnchor.constraint(equalTo: latLabel.trailingAnchor, constant: 5),

            cityLabel.topAnchor.constraint(equalTo: latLabel.bottomAnchor, constant: 10),
            cityLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),

            tempLabel.topAnchor.constraint(equalTo: cityLabel.bottomAnchor, constant: 10),
            tempLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),

            segmentedControl.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -25),
            segmentedControl.centerYAnchor.constraint(equalTo: tempLabel.centerYAnchor),
            segmentedControl.heightAnchor.constraint(equalToConstant: 40),
            segmentedControl.widthAnchor.constraint(equalToConstant: 80)

        ])

    }

}
