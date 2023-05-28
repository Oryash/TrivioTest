//
//  PanelView.swift
//  TrivioTest
//
//  Created by Anvar Bagautdinov on 27.05.2023.
//

import UIKit

class PanelView: UIView {

    //MARK: - Properties

    struct Constants {
        static let labelFont: CGFloat = 20
        static let constraint5: CGFloat = 5
        static let constraint10: CGFloat = 10
        static let constraint15: CGFloat = 15
        static let constraint20: CGFloat = 20
        static let constraint25: CGFloat = 25
        static let constraint40: CGFloat = 40
        static let constraint80: CGFloat = 80
    }

    private(set) lazy var latLabel: UILabel = {
        var label = UILabel()
        label.backgroundColor = .white
        label.textColor = .black
        label.text = Strings.lat.getString()
        label.font = label.font.withSize(Constants.labelFont)
        return label
    }()

    private(set) lazy var lonLabel: UILabel = {
        var label = UILabel()
        label.backgroundColor = .white
        label.textColor = .black
        label.text = Strings.lon.getString()
        label.font = label.font.withSize(Constants.labelFont)
        return label
    }()

    private(set) lazy var cityLabel: UILabel = {
        var label = UILabel()
        label.backgroundColor = .white
        label.textColor = .black
        label.text = Strings.city.getString()
        label.font = label.font.withSize(Constants.labelFont)
        return label
    }()

    private(set) lazy var tempLabel: UILabel = {
        var label = UILabel()
        label.backgroundColor = .white
        label.textColor = .black
        label.text = Strings.temperature.getString()
        label.font = label.font.withSize(Constants.labelFont)
        return label
    }()

    private(set) lazy var segmentedControl: UISegmentedControl = {
        let items = ["C", "F"]
        var segment = UISegmentedControl(items: items)
        segment.selectedSegmentIndex = 0
        segment.addTarget(self, action: #selector(segmentedControlChanged), for: .valueChanged)
        return segment
    }()

    var segmentedControlCallback: (UISegmentedControl) -> () = { _ in }

    //MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        backgroundColor = .white
        layer.borderWidth = 0.5
        setConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: - Methods

    @objc private func segmentedControlChanged(_ segmentedControl: UISegmentedControl) {
        segmentedControlCallback(segmentedControl)
    }

    func changeLabelText(text: String, UIElement: UIView) {
        switch UIElement {
        case latLabel:
            latLabel.text = text
        case lonLabel:
            lonLabel.text = text
        case cityLabel:
            cityLabel.text = text
        case tempLabel:
            tempLabel.text = text
        default:
            return
        }
    }

    private func setConstraints() {
        self.addSubviews(latLabel, lonLabel, cityLabel, tempLabel, segmentedControl)

        NSLayoutConstraint.activate([

            latLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: Constants.constraint15),
            latLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Constants.constraint20),

            lonLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: Constants.constraint15),
            lonLabel.leadingAnchor.constraint(equalTo: latLabel.trailingAnchor, constant: Constants.constraint5),

            cityLabel.topAnchor.constraint(equalTo: latLabel.bottomAnchor, constant: Constants.constraint10),
            cityLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Constants.constraint20),

            tempLabel.topAnchor.constraint(equalTo: cityLabel.bottomAnchor, constant: Constants.constraint10),
            tempLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Constants.constraint20),

            segmentedControl.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -Constants.constraint25),
            segmentedControl.centerYAnchor.constraint(equalTo: tempLabel.centerYAnchor),
            segmentedControl.heightAnchor.constraint(equalToConstant: Constants.constraint40),
            segmentedControl.widthAnchor.constraint(equalToConstant: Constants.constraint80)

        ])

    }

}
