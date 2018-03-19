//
//  User.swift
//  King of Song Quiz
//
//  Created by Moon on 2018/3/9.
//  Copyright © 2018年 Marvin Lin. All rights reserved.
//

import Foundation
import Firebase

enum UserState: Int {
    case justInit = 0
    case gotUserId
}

class User {

    var ref: DatabaseReference!
    var userId: String = ""
    var state = UserState.justInit
    
    init() {
        ref = Database.database().reference()
    }
    
    func requestId() {
        // FIXME: 要寫成 protocol 嗎
    }
}
