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

func createSignUpPageGradient(target uIView: UIView) {

    gradientLayer = CAGradientLayer()

    gradientLayer.frame = uIView.bounds

    gradientLayer.colors = [UIColor.mldLightRoyalBlue.cgColor, UIColor.mldLightRoyalBlue.cgColor, UIColor.mldPurplePink.cgColor]

    gradientLayer.opacity = 0.5

    uIView.layer.insertSublayer(gradientLayer, at: 0)

}

func createProfileViewOfResult(target uIView: UIView) {

    gradientLayer = CAGradientLayer()

    gradientLayer.frame = uIView.bounds

    gradientLayer.colors = [UIColor.mldBarney80.cgColor, UIColor.mldUltramarineBlue.cgColor]

    uIView.layer.insertSublayer(gradientLayer, at: 0)

}

func createNextBattleOfResult(target uILabel: UILabel) {

    gradientLayer = CAGradientLayer()

    gradientLayer.frame = uILabel.bounds

    gradientLayer.colors = [UIColor.mldDuckEggBlue.cgColor, UIColor.mldTiffanyBlue.cgColor]

    uILabel.layer.insertSublayer(gradientLayer, at: 0)

    uILabel.layer.cornerRadius = 25

    uILabel.layer.masksToBounds = true

}

func createProfilePageHistoryCellBackground(target uIView: UIView) {
    
    gradientLayer = CAGradientLayer()
    
    gradientLayer.frame = uIView.bounds
    
    gradientLayer.colors = [UIColor.mldUltramarineBlueTwo.cgColor, UIColor.mldUltramarine.cgColor]
    
    uIView.layer.insertSublayer(gradientLayer, at: 0)
    
}
