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

    var mandarinPopDistractorMO: MandarinPopDistractorMO!

    var mandarinPopDistractorArray = [MandarinPopDistractorMO]()

    var ref: DatabaseReference!

    var distractors = [String]()

    weak var delegate: DistractorManagerDelegate?

    var distractorIDArray = [Int]()

    var saveContextTrigger: Int = 0

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

            if self.distractors.count == self.saveContextTrigger {

                self.saveDistractorArrayToCoreData(input: self.distractors)
            }

        })
    }

    func getDistractorIDArray(arrayCount count: Int, distractorBankCount bankMax: Int) -> [Int] {

        self.saveContextTrigger = count

        var returnArray = [Int]()

        while returnArray.count != count {

            let distractorID = random(bankMax)

            if returnArray.contains(distractorID) == false {
                returnArray.append(distractorID)
            }
        }

        distractorIDArray = returnArray

        for eachDistractorID in distractorIDArray {

            getOneDistractor(input: eachDistractorID)

        }

        return distractorIDArray
    }

    func saveDistractorArrayToCoreData(input distractorArray: [String]) {

        for eachDistractor in distractorArray {

            if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {

                self.mandarinPopDistractorMO = MandarinPopDistractorMO(context: appDelegate.persistentContainer.viewContext)

                self.mandarinPopDistractorMO.distractorStr = eachDistractor

                print("你存入了 \(eachDistractor) 在 Distractor CoreData 中")

                appDelegate.saveContext()

            }

        }
    }
}
