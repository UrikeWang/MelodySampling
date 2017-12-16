//
//  addSpace.swift
//  MelodySampling
//
//  Created by moon on 2017/8/9.
//  Copyright © 2017年 Marvin Lin. All rights reserved.
//

import Foundation
import UIKit

extension UILabel {
    func addTextSpacing(to spacing: Double) {
        if let textString = text {
            let attributedString = NSMutableAttributedString(string: textString)
            attributedString.addAttribute(NSKernAttributeName, value: spacing, range: NSRange(location: 0, length: attributedString.length - 1))
            attributedText = attributedString
        }
    }
}
