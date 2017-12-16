//
//  ScoresFunc.swift
//  MelodySampling
//
//  Created by moon on 2017/8/8.
//  Copyright © 2017年 Marvin Lin. All rights reserved.
//

import Foundation

func scoreAfterOneSong(time usedTime: Double) -> Double {

    let score: Double?

    if usedTime > 30.0 {
        score = 600.0
    } else {
        score = 3600.0 - 100.0 * usedTime
    }

    return Double(score!)

}
