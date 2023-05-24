//
//  UIView + Extensions.swift
//  TrivioTest
//
//  Created by Anvar Bagautdinov on 24.05.2023.
//

import UIKit

extension UIView {

    func addSubviews(_ views: UIView..., maskConstraints: Bool = false) {
        views.forEach{
            $0.translatesAutoresizingMaskIntoConstraints = maskConstraints
            addSubview($0)
        }
    }
}
