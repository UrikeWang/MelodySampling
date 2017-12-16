//
//  UIShadowCreator.swift
//  MelodySampling
//
//  Created by moon on 2017/8/21.
//  Copyright © 2017年 Marvin Lin. All rights reserved.
//

import Foundation
import UIKit

func createTitleLabelShadow(target uILabel: UILabel) {

    uILabel.layer.shadowColor = UIColor.mldBlack50.cgColor
    uILabel.layer.shadowOffset = CGSize(width: 0, height: 10)
    uILabel.layer.shadowRadius = 10
}
