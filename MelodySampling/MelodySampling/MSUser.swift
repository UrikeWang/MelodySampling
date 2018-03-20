//
//  MSUser.swift
//  King of Song Quiz
//
//  Created by Moon on 2018/3/17.
//  Copyright © 2018年 Marvin Lin. All rights reserved.
//

import Foundation

class MSUser: User {
    
    private let createdTime: Double? = nil
    private var fullName: String? = nil
    private var isAnonymous: Bool? = nil
    private var profilePicURL: String? = nil
    private let userAccount: String? = nil
    private let wasAnonymous: Bool? = nil
    
    override func requestId() {
        // FIXME: 目前不確定在什麼時候發動 requestId，因為這些資訊平常都存在本機上， firebase 上的資料都是本機打上去的
    }
}
