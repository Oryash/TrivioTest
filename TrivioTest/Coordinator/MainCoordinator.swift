//
//  MainCoordinator.swift
//  TrivioTest
//
//  Created by Anvar Bagautdinov on 24.05.2023.
//

import UIKit

final class MainCoordinator: CoordinatorProtocol {

    var navigationController: UINavigationController?

    //MARK: - Internal Methods

    func eventOccurred(with type: Event) {
        switch type {
        case .buttonPressed:
            var vc: UIViewController & Coordinating = LocationsViewController()
            vc.coordinator = self
            vc.title = Strings.location.getString()
            navigationController?.pushViewController(vc, animated: true)
        }
    }


    func start() {
        var vc: UIViewController & Coordinating = MapViewController()
        vc.coordinator = self

        if #available(iOS 15.0, *) {

            let navBarAppearance = UINavigationBarAppearance()
            navBarAppearance.configureWithOpaqueBackground()
            UINavigationBar.appearance().standardAppearance = navBarAppearance
            UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearance
        }
        navigationController?.setViewControllers([vc], animated: false)
    }
}
