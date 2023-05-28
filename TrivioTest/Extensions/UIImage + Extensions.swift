//
//  UIImage + Extensions.swift
//  TrivioTest
//
//  Created by Anvar Bagautdinov on 25.05.2023.
//

import UIKit

extension UIImage {
    
    func scaleToSize(_ size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        defer { UIGraphicsEndImageContext() }
        self.draw(in: CGRect(origin: .zero, size: size))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
