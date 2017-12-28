//
//  RandomUserStruct.swift
//  King of Song Quiz
//
//  Created by Meng Hsien Lin on 2017/12/25.
//  Copyright © 2017年 Marvin Lin. All rights reserved.
//

import Foundation


struct RandomUser: Decodable {
    
    var results: [Results]
    var info: Info
    
    struct Results: Decodable {
        var gender: String
        var name: Name
        var location: Location
        var email: String
        var login: Login
        var dob: String
        var registered: String
        var phone: String
        var cell: String
        var id: ID
        var picture: Picture
        var nat: String
    }
    
    struct Picture: Decodable {
        var large: String
        var medium: String
        var thumbnail: String
    }
    
    struct ID: Decodable {
        var name: String
        var value: String?
    }
    
    struct Login: Decodable {
        var username: String
        var password: String
        var salt: String
        var md5: String
        var sha1: String
        var sha256: String
    }
    
    
    struct Location: Decodable {
        var street: String
        var city: String
        var state: String
        var postcode: Int
    }
    
    struct Name: Decodable {
        var title: String
        var first: String
        var last: String
    }
    
    struct Info: Decodable {
        var seed: String
        var results: Int
        var page: Int
        var version: String
    }
}
