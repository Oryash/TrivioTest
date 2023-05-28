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
        case .btnPressed:
            var vc: UIViewController & Coordinating = LocationsViewController()
            vc.coordinator = self
            vc.title = Strings.Локации.getString()
            vc.navigationController?.navigationBar.barTintColor = .black
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
        vc.title = Strings.Карта.getString()
        navigationController?.setViewControllers([vc], animated: false)
    }
}
