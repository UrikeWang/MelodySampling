//
//  User.swift
//  King of Song Quiz
//
//  Created by Moon on 2018/3/9.
//  Copyright © 2018年 Marvin Lin. All rights reserved.
//

import Foundation

class User {

    // FIXME: 目前是依照現有設定而開 property，但這不符合未來需求，還要再改
    
    private var userId: String? = nil
    private let createdTime: Double? = nil
    private var fullName: String? = nil
    private var isAnonymous: Bool
    private var profilePicURL: String? = nil
    private let userAccount: String? = nil
    private let wasAnonymous: Bool
    
    init(isAnonymous: Bool, wasAnonymous: Bool) {
        self.isAnonymous = isAnonymous
        self.wasAnonymous = wasAnonymous
    }
}
