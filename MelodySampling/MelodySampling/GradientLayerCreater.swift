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

    uILabel.layer.insertSublayer(gradientLayer, at: 0)
}

func createSignUpPageGradient(target uIView: UIView, height screenH: Int) {

    gradientLayer = CAGradientLayer()

    gradientLayer.frame = CGRect(x: 0, y: 0, width: 600, height: screenH)

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

func createUserProfileImage(targe uIImageView: UIImageView) {

    uIImageView.layer.shadowColor = UIColor.mldBlack50.cgColor
    uIImageView.layer.shadowOffset = CGSize(width: 2, height: 2)
    uIImageView.layer.shadowRadius = 4
}

func createUserProfilePageLogoutBackground(target uIView: UIView) {

    gradientLayer = CAGradientLayer()

    gradientLayer.frame = uIView.bounds

    gradientLayer.colors = [UIColor.mldLightPurple.cgColor, UIColor.mldLighterPurple.cgColor, UIColor.mldLighterPurpleTwo.cgColor]

    uIView.layer.insertSublayer(gradientLayer, at: 0)

}

func createResultBackground(target uIView: UIView, height screenH: Int) {
    gradientLayer = CAGradientLayer()

    gradientLayer.frame = CGRect(origin: CGPoint.init(x: 0, y: 0), size: CGSize(width: 500, height: screenH))

        gradientLayer.colors = [UIColor.mldLightRoyalBlue.cgColor, UIColor.mldLightRose.cgColor]

    uIView.layer.insertSublayer(gradientLayer, at: 0)

}
