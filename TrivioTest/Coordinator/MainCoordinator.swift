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
        navigationController?.setViewControllers([vc], animated: false)
    }

}
