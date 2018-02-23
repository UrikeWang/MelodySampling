//
//  Styleguide.swift
//  MelodySampling
//
//  Created by moon on 2017/8/7.
//  Copyright © 2017年 Marvin Lin. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    class var mldPurplePink: UIColor {
        return UIColor(red: 236.0 / 255.0, green: 81.0 / 255.0, blue: 224.0 / 255.0, alpha: 1.0)
    }

    class var mldBlueBlue: UIColor {
        return UIColor(red: 38.0 / 255.0, green: 63.0 / 255.0, blue: 193.0 / 255.0, alpha: 1.0)
    }

    class var mldLightRoyalBlue: UIColor {
        return UIColor(red: 66.0 / 255.0, green: 34.0 / 255.0, blue: 254.0 / 255.0, alpha: 1.0)
    }

    class var mldDuckEggBlue: UIColor {
        return UIColor(red: 205.0 / 255.0, green: 248.0 / 255.0, blue: 242.0 / 255.0, alpha: 1.0)
    }

    class var mldTiffanyBlue: UIColor {
        return UIColor(red: 158.0 / 255.0, green: 239.0 / 255.0, blue: 225.0 / 255.0, alpha: 1.0)
    }

    class var mldWhite90: UIColor {
        return UIColor(white: 238.0 / 255.0, alpha: 0.9)
    }

    class var mldWhite: UIColor {
        return UIColor(white: 238.0 / 255.0, alpha: 1.0)
    }

    class var playPageBackground: UIColor {
        return UIColor(red: 66.0 / 255.0, green: 34.0 / 255.0, blue: 254.0 / 255.0, alpha: 1.0)
    }

    class var mldBarney80: UIColor {
        return UIColor(red: 193.0 / 255.0, green: 31.0 / 255.0, blue: 180.0 / 255.0, alpha: 0.8)
    }

    class var mldUltramarineBlue: UIColor {
        return UIColor(red: 34.0 / 255.0, green: 0.0, blue: 231.0 / 255.0, alpha: 1.0)
    }

    class var mldBlack50: UIColor {
        return UIColor(white: 0.0, alpha: 0.5)
    }

    class var mldUltramarineBlueTwo: UIColor {
        return UIColor(red: 52.0 / 255.0, green: 0.0, blue: 208.0 / 255.0, alpha: 1.0)
    }

    class var mldUltramarine: UIColor {
        return UIColor(red: 24.0 / 255.0, green: 0.0, blue: 163.0 / 255.0, alpha: 1.0)
    }

    class var mldSapphire: UIColor {
        return UIColor(red: 56.0 / 255.0, green: 34.0 / 255.0, blue: 151.0 / 255.0, alpha: 1.0)
    }

    class var mldLightPurple: UIColor {
        return UIColor(red: 194.0 / 255.0, green: 123.0 / 255.0, blue: 249.0 / 255.0, alpha: 1.0)
    }

    class var mldLighterPurple: UIColor {
        return UIColor(red: 168.0 / 255.0, green: 95.0 / 255.0, blue: 244.0 / 255.0, alpha: 1.0)
    }

    class var mldLighterPurpleTwo: UIColor {
        return UIColor(red: 143.0 / 255.0, green: 69.0 / 255.0, blue: 240.0 / 255.0, alpha: 1.0)
    }

    class var mldDarkIndigo40: UIColor {
        return UIColor(red: 25.0 / 255.0, green: 13.0 / 255.0, blue: 94.0 / 255.0, alpha: 0.4)
    }

    class var mldLightRose: UIColor {
        return UIColor(red: 254.0 / 255.0, green: 205.0 / 255.0, blue: 211.0 / 255.0, alpha: 1.0)
    }

    class var mldOrangeRed: UIColor {
        return UIColor(red: 254.0 / 255.0, green: 56.0 / 255.0, blue: 36.0 / 255.0, alpha: 1.0)
    }

    class var mldAppleGreen: UIColor {
        return UIColor(red: 126.0 / 255.0, green: 211.0 / 255.0, blue: 33.0 / 255.0, alpha: 1.0)
    }
    
    class var sqOrangeRed: UIColor {
        return UIColor(red: 254.0 / 255.0, green: 56.0 / 255.0, blue: 36.0 / 255.0, alpha: 1.0)
    }
    
    class var sqAppleGreen: UIColor {
        return UIColor(red: 126.0 / 255.0, green: 211.0 / 255.0, blue: 33.0 / 255.0, alpha: 1.0)
    }
    
    class var sqCelery: UIColor {
        return UIColor(red: 208.0 / 255.0, green: 255.0 / 255.0, blue: 157.0 / 255.0, alpha: 1.0)
    }
    
    class var sqPaleSalmon: UIColor {
        return UIColor(red: 255.0 / 255.0, green: 184.0 / 255.0, blue: 177.0 / 255.0, alpha: 1.0)
    }

}

// Text styles

extension UIFont {
    class func mldTextStyle10Font() -> UIFont? {
        return UIFont(name: "Montserrat-Medium", size: 30.0)
    }

    class func mldTextStyleEmptyFont() -> UIFont? {
        return UIFont(name: "Montserrat-Medium", size: 30.0)
    }

    class func mldTextStyleCountDownFont() -> UIFont? {
        return UIFont(name: "Montserrat-Medium", size: 40.0)
    }

}
