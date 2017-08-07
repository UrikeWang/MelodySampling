//
//  OutletFunction.swift
//  MelodySampling
//
//  Created by moon on 2017/8/7.
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
