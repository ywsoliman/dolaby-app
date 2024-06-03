//
//  CustomTabBar.swift
//  ShopifyApp
//
//  Created by Israa Assem on 01/06/2024.
//

import UIKit

class CustomTabBar: UITabBar {
    private var shapeLayer: CAShapeLayer?

    override func layoutSubviews() {
        super.layoutSubviews()

        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowRadius = 5
        layer.masksToBounds = false

        if shapeLayer == nil {
            let newShapeLayer = CAShapeLayer()
            newShapeLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: 40).cgPath
            newShapeLayer.fillColor = UIColor.white.cgColor

            newShapeLayer.shadowColor = layer.shadowColor
            newShapeLayer.shadowOpacity = layer.shadowOpacity
            newShapeLayer.shadowOffset = layer.shadowOffset
            newShapeLayer.shadowRadius = layer.shadowRadius
            layer.insertSublayer(newShapeLayer, at: 0)
            shapeLayer = newShapeLayer
        } else {
            shapeLayer?.path = UIBezierPath(roundedRect: bounds, cornerRadius: 40).cgPath
            shapeLayer?.frame = bounds
        }
    }
}

