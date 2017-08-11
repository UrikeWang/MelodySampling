//
//  ResultStructure.swift
//  MelodySampling
//
//  Created by moon on 2017/8/10.
//  Copyright © 2017年 Marvin Lin. All rights reserved.
//

import Foundation
import UIKit

struct EachSongResult {
    let artistName: String
    let trackName: String
    let artworkUrl30: UIImage
    let result: Bool
    let usedTime: Double

}

struct DictionaryToResult {

    let score: Double
    let song0: EachSongResult
    let song1: EachSongResult
    let song2: EachSongResult
    let song3: EachSongResult
    let song4: EachSongResult

}
