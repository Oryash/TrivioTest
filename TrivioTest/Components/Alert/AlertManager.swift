//
//  AlertManager.swift
//  TrivioTest
//
//  Created by Anvar Bagautdinov on 28.05.2023.
//

import UIKit

protocol ManagesAlert {
    func showAlert(with viewModel: AlertManagerViewModel, on viewController: UIViewController)
}

final class AlertManager: ManagesAlert {

    // MARK: - Properties

    static let shared = AlertManager()

    // MARK: - Methods

    func showAlert(with viewModel: AlertManagerViewModel, on viewController: UIViewController) {

        let alert = UIAlertController(title: viewModel.title, message: viewModel.message, preferredStyle: viewModel.alertStyle)

        viewModel.actions.forEach { alert.addAction($0) }

        viewController.present(alert, animated: viewModel.isAnimated, completion: viewModel.alertAppearedAction)
    }
}
