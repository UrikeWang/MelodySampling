//
//  ResultStructure.swift
//  MelodySampling
//
//  Created by moon on 2017/8/10.
//  Copyright © 2017年 Marvin Lin. All rights reserved.
//

import Foundation
import UIKit

struct EachQuestion {
    let artistID: Int
    let artistName: String
    let trackID: Int
    let trackName: String
    let artworkUrl30: String //只存網址
    let previewUrl: String
    let collectionID: Int
    let collectionName: String
    let primaryGenreName: String
}

struct EachSongResult {
    let result: Bool
    let usedTime: Double
    let questionDetail: EachQuestion

}

struct DictionaryToResult {
    let score: Double
    let song0: EachSongResult
    let song1: EachSongResult
    let song2: EachSongResult
    let song3: EachSongResult
    let song4: EachSongResult

}
