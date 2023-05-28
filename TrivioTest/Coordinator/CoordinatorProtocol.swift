//
//  CoordinatorProtocol.swift
//  TrivioTest
//
//  Created by Anvar Bagautdinov on 24.05.2023.
//

import UIKit

enum Event {
    case buttonPressed
}

protocol CoordinatorProtocol {
    var navigationController: UINavigationController? { get set }

    func eventOccurred(with type: Event)
    func start()
}

protocol Coordinating {
    var coordinator: CoordinatorProtocol? { get set }
}
