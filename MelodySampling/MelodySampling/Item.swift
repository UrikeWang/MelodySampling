//
//  Item.swift
//  King of Song Quiz
//
//  Created by Moon on 2018/3/9.
//  Copyright © 2018年 Marvin Lin. All rights reserved.
//

import Foundation

protocol ItemEffect {
    func itemEffect()
}

class Item: ItemEffect {
    
    var itemName: String = "Item"
    var isUsable: Bool = true
    unowned var owner: User
    
    init(owner: User) {
        self.owner = owner
    }
    
    func toggle() {
        isUsable = !isUsable
    }
    
    func itemEffect() {
    }
}
