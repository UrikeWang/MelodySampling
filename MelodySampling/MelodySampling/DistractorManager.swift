//
//  DistractorManager.swift
//  MelodySampling
//
//  Created by moon on 2017/8/18.
//  Copyright © 2017年 Marvin Lin. All rights reserved.
//

import UIKit
import Foundation
import Firebase
import CoreData
import SwiftyJSON

class DistractorManager {
    
    var ref: DatabaseReference!
    
    func getDistractorListArray(input random: String) {
        
        ref = Database.database().reference()
        
        
        let randomStr = String(random)
        ref.child("distractorBanks").child("mandarinPop").child("allList").queryOrderedByKey().queryEqual(toValue: randomStr).observeSingleEvent(of: .value, with: { (snapshot) in
            
            let json = JSON(snapshot.value)
            
            print(json)
            print(type(of: json))
            
            print("歌名: \(json[randomStr!].stringValue)")
            
        })
    }

}
