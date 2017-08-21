//
//  FirebaseExtension.swift
//  MelodySampling
//
//  Created by moon on 2017/8/13.
//  Copyright © 2017年 Marvin Lin. All rights reserved.
//

import Foundation
import Firebase
import SwiftyJSON

extension DataSnapshot {
    var json: JSON {
        return JSON(self.value as Any)
    }
}
