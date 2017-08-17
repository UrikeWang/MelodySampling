//
//  LabelCreator.swift
//  MelodySampling
//
//  Created by moon on 2017/8/17.
//  Copyright © 2017年 Marvin Lin. All rights reserved.
//

import Foundation
import UIKit

func createLabel(at uIView: UIView, content text: String, color colorInput: UIColor, font fontInput: UIFont) -> UILabel {

    let frame = uIView.frame

    let label = UILabel(frame: frame)

    label.textAlignment = .center

    label.text = text

        label.textColor = colorInput

        label.font = fontInput

//    uIView.addSubview(label)
    return label
}
