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

//失敗了，重新想一個方式
//如果我只要15個，那就直接使用 random，範圍就在 firebase 上的題庫最大值，然後塞入 seedArray, while seedArray.count <15, 就不斷的取值，每一次取值都要比對 seedArray 裡面的值，沒出現過的才塞入。

protocol DistractorManagerDelegate: class {

    func manager(_ manager: DistractorManager, didGet distractors: [String])
    func manager(_ manager: DistractorManager, didFailWith error: Error)
}

class DistractorManager {

    var ref: DatabaseReference!

    var distractors = [String]()

    weak var delegate: DistractorManagerDelegate?

    var distractorIDArray = [Int]()
    
    enum RequestDistractorsError: Error {

        case invalidResponse
    }

    func getOneDistractor(input random: Int) {

        ref = Database.database().reference()

        let randomStr = "distractor" + String(random)
        ref.child("distractorBanks").child("taiwanesePop").child("allList").queryOrderedByKey().queryEqual(toValue: randomStr).observeSingleEvent(of: .value, with: { (snapshot) in

            let json = JSON(snapshot.value)

            print(json)
            print(type(of: json))

            print("歌名: \(json[randomStr].stringValue)")
            
            self.distractors.append(json[randomStr].stringValue)
            
            print("這是 distractors \(self.distractors)")

        })
    }

    func getDistractorIDArray(arrayCount count: Int, distractorBankCount bankMax: Int) -> [Int] {

        var returnArray = [Int]()

        while returnArray.count != count {

            let distractorID = random(bankMax)

            if returnArray.contains(distractorID) == false {
                returnArray.append(distractorID)
            }
        }
        
        distractorIDArray = returnArray

        return distractorIDArray
    }
    
    func getDistractorArray() {
        
        
        
    }

}
