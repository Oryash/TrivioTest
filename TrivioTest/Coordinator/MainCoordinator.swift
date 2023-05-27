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

//    func eventOccurred(with type: Event) {
//        switch type {
//        case .appLoaded:
//            var vc: UIViewController & Coordinating = MapViewController()
//            vc.coordinator = self
//            navigationController?.viewControllers.removeAll()
//            navigationController?.pushViewController(vc, animated: true)
//        }
//    }


    func start() {
        var vc: UIViewController & Coordinating = MapViewController()
        vc.coordinator = self
//        navigationController?.navigationBar.barTintColor = .white
//        navigationController?.navigationBar.tintColor = .white
//        navigationController?.navigationBar.barStyle = .default

//        navigationController?.navigationBar.isTranslucent = false

        if #available(iOS 15.0, *) {

            let navBarAppearance = UINavigationBarAppearance()
            navBarAppearance.configureWithOpaqueBackground()
            //Configure additional customizations here
            UINavigationBar.appearance().standardAppearance = navBarAppearance
            UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearance
        }
        vc.title = "Карта"
        navigationController?.setViewControllers([vc], animated: false)
    }

}
