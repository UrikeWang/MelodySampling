//
//  OneOfTwoItem.swift
//  King of Song Quiz
//
//  Created by Moon on 2018/3/10.
//  Copyright © 2018年 Marvin Lin. All rights reserved.
//

import Foundation

protocol Comsumable {
    
    var quantity: Int { get }
    func add(by addedQuantity: Int)
    func comsume()
    
}

class OnvarTwoItem: Item, Comsumable {
    
    var quantity = 0
    
    override init(owner: User) {
        super.init(owner: owner)
        itemName = NSLocalizedString("One of Two", comment: "Cut 2 distractors during game")
    }
    
    override func itemEffect() {
        // FIXME: 使用後發動效果，之後再實作
    }
    
    func add(by addedQuantity: Int) {
        quantity += addedQuantity
    }
    
    func comsume() {
        if quantity > 0 && isUsable {
            quantity -= 1
        }
    }
    
}
