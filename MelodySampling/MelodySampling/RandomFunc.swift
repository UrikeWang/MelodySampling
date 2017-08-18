//
//  RandomFunc.swift
//  MelodySampling
//
//  Created by moon on 2017/8/18.
//  Copyright © 2017年 Marvin Lin. All rights reserved.
//

import Foundation

func random(_ inputN: Int) -> Int {
    return Int(arc4random_uniform(UInt32(inputN)))
}
