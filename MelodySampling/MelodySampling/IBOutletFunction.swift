//
//  IBOutletFunction.swift
//  MelodySampling
//
//  Created by moon on 2017/8/15.
//  Copyright © 2017年 Marvin Lin. All rights reserved.
//

import Foundation
import UIKit

func setCornerRadiustTo(_ uILabel: UILabel) {

    uILabel.layer.cornerRadius = 25
    uILabel.layer.masksToBounds = true
}

func setInvisibleTo(_ uIButton: UIButton) {
    uIButton.setTitleColor(UIColor.clear, for: .normal)
}

func setCoverView(_ uIView: UIView, width setWidth: CGFloat, height setHeight: CGFloat) {

    uIView.frame = CGRect(x: 0, y: 0, width: setWidth, height: setHeight)

    uIView.backgroundColor = UIColor.mldBlack50

}

func setCountDownLabelStyle(_ uILabel: UILabel, screen setScreen: UIScreen, height setHeight: CGFloat, width setWidth: CGFloat) {

    uILabel.frame = CGRect(x: setScreen.bounds.width/2 - setWidth/2, y: setScreen.bounds.height/2 - setHeight/2, width: setWidth, height: setHeight)

    uILabel.layer.cornerRadius = setWidth/2

    uILabel.clipsToBounds = true

    uILabel.backgroundColor = UIColor.mldWhite90

    uILabel.textColor = UIColor.black

    uILabel.textAlignment = .center

    uILabel.font = UIFont.mldTextStyleCountDownFont()
}
