//
//  UIStackView+Extensions.swift
//  RandDog
//
//  Created by Akan Akysh on 8/26/19.
//  Copyright © 2019 Akysh Akan. All rights reserved.
//

import Foundation
import UIKit

extension UIStackView {
    
    // To change stackView background color
    func changeBackgroundColor(color: UIColor) {
        let backgroundLayer = CAShapeLayer()
        self.layer.insertSublayer(backgroundLayer, at: 0)
        backgroundLayer.path = UIBezierPath(rect: self.bounds).cgPath
        backgroundLayer.fillColor = color.cgColor
    }
}
