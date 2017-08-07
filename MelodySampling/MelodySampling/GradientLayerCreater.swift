//
//  GradientLayerCreater.swift
//  MelodySampling
//
//  Created by moon on 2017/8/7.
//  Copyright © 2017年 Marvin Lin. All rights reserved.
//

import Foundation
import UIKit

var gradientLayer: CAGradientLayer!

func createGradientOnLabel(target uILabel: UILabel) {
    
    gradientLayer = CAGradientLayer()
    
    gradientLayer.frame = uILabel.bounds
    
    gradientLayer.colors = [UIColor.mldPurplePink.cgColor, UIColor.mldBlueBlue.cgColor, UIColor.mldPurplePink.cgColor]
    
    gradientLayer.startPoint = CGPoint(x:0.0, y:0.5)
    
    gradientLayer.endPoint = CGPoint(x:1.0, y:0.5)
    
    uILabel.layer.addSublayer(gradientLayer)
}
