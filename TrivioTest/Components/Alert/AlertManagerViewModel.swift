//
//  AlertManagerViewModel.swift
//  TrivioTest
//
//  Created by Anvar Bagautdinov on 28.05.2023.
//

import UIKit

struct AlertManagerViewModel {
    let title: String
    let message: String
    var actions: [UIAlertAction]
    var alertStyle: UIAlertController.Style
    var alertAppearedAction: (() -> Void)?
    var isAnimated: Bool

    init(
        title: String,
        message: String,
        actions: [UIAlertAction],
        alertStyle: UIAlertController.Style = .alert,
        alertAppearedAction: ( () -> Void)? = nil,
        isAnimated: Bool = true) {
        self.title = title
        self.message = message
        self.alertStyle = alertStyle
        self.alertAppearedAction = alertAppearedAction
        self.actions = actions
        self.isAnimated = isAnimated
    }
}
