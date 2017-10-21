//
//  AnimationFunc.swift
//  King of Song Quiz
//
//  Created by moon on 2017/10/22.
//  Copyright © 2017年 Marvin Lin. All rights reserved.
//

import Foundation
import UIKit

func addOpacityAnimation(label: UILabel) {
    let key = "opacity"
    let animation = CABasicAnimation(keyPath: key)
    animation.fromValue = 1.0
    animation.toValue = 0.0
    animation.duration = 0.5
    animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
    animation.autoreverses = true
    animation.repeatCount = FLT_MAX
    label.layer.add(animation, forKey: key)
}
