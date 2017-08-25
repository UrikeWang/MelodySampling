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
    let artworkUrl: String //只存網址
    let previewUrl: String
    let collectionID: Int
    let collectionName: String
    let primaryGenreName: String
}

struct EachSongResult {
    let index: Int16
    let result: Bool
    let usedTime: Double
}

struct SendToFirebase {
    let artistID: Int
    let artistName: String
    let trackID: Int
    let trackName: String
    let artworkUrl: String
    let previewUrl: String
    let collectionID: Int
    let collectionName: String
    let primaryGenreName: String
    let index: Int
    let result: Bool
    let usedTime: Double
    let choosedAnswer: String
    
}
