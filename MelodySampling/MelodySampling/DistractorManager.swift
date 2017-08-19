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

    var billboardPopDistractorMO: BillboardPopDistractorMO!

    var taiwanesePopDistractorMO: TaiwanesePopDistractorMO!

    var cantoPopDistractorMO: CantoPopDistractorMO!

    var ref: DatabaseReference!

    var distractors = [String]()

    weak var delegate: DistractorManagerDelegate?

    var distractorIDArray = [Int]()

    var saveContextTrigger: Int = 0

    enum TypeList: String {
        case mandarinPop, taiwanesePop, cantoPop, billboardPop
    }

    var typeList: [TypeList] = [.mandarinPop, .taiwanesePop, .cantoPop, .billboardPop]

    enum RequestDistractorsError: Error {

        case invalidResponse
    }

    func getOneDistractor(input random: Int, genre genreInput: String) {

        ref = Database.database().reference()

        let randomStr = "distractor" + String(random)

        ref.child("distractorBanks").child(genreInput).child("allList").queryOrderedByKey().queryEqual(toValue: randomStr).observeSingleEvent(of: .value, with: { (snapshot) in

            let json = JSON(snapshot.value)

//            print("歌名: \(json[randomStr].stringValue)")

            self.distractors.append(json[randomStr].stringValue)

            if self.distractors.count == self.saveContextTrigger {

                switch (genreInput) {

                case TypeList.mandarinPop.rawValue:
                    print("Trigger Mandarin")
                    self.saveMandarinDistractors(input: self.distractors)

                case TypeList.taiwanesePop.rawValue:
                    print("Trigger Taiwanese")
                    self.saveTaiwaneseDistractors(input: self.distractors)

                case TypeList.cantoPop.rawValue:
                    print("Trigger cantoPop")
                    self.saveCantoDistractors(input: self.distractors)

                case TypeList.billboardPop.rawValue:
                    print("Trigger billboard")
                    self.saveBillboardDistractors(input: self.distractors)

                default:
                    print("Trigger Mandarin(default)")
                    self.saveMandarinDistractors(input: self.distractors)

                }
            }

        })
    }

    func getDistractorIDArray(distractorArrayCount count: Int, distractorBankCount bankMax: Int, genre genreInput: String) {

        self.distractors = []

        self.saveContextTrigger = count

        var returnArray = [Int]()

        while returnArray.count != count {

            let distractorID = random(bankMax)

            if returnArray.contains(distractorID) == false {
                returnArray.append(distractorID)
            }
        }

        distractorIDArray = returnArray

        for eachGenre in typeList {
            for eachDistractorID in returnArray {

                getOneDistractor(input: eachDistractorID, genre: eachGenre.rawValue)

            }
        }
    }

    func saveMandarinDistractors(input distractorArray: [String]) {

        for eachDistractor in distractorArray {

            if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {

                self.mandarinPopDistractorMO = MandarinPopDistractorMO(context: appDelegate.persistentContainer.viewContext)

                self.mandarinPopDistractorMO.distractorStr = eachDistractor

                print("你存入了 \(eachDistractor) 在 Mandarin Distractor CoreData 中")

                appDelegate.saveContext()

            }

        }
    }

    func saveBillboardDistractors(input distractorArray: [String]) {

        for eachDistractor in distractorArray {

            if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {

                self.billboardPopDistractorMO = BillboardPopDistractorMO(context: appDelegate.persistentContainer.viewContext)

                self.billboardPopDistractorMO.distractorStr = eachDistractor

                print("你存入了 \(eachDistractor) 在 Billboard Distractor CoreData 中")

                appDelegate.saveContext()
            }

        }
    }

    func saveTaiwaneseDistractors(input distractorArray: [String]) {

        for eachDistractor in distractorArray {

            if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {

                self.taiwanesePopDistractorMO = TaiwanesePopDistractorMO(context: appDelegate.persistentContainer.viewContext)

                self.taiwanesePopDistractorMO.distractorStr = eachDistractor

                print("你存入了 \(eachDistractor) 在 Taiwanese Distractor CoreData 中")

                appDelegate.saveContext()
            }

        }

    }

    func saveCantoDistractors(input distractorArray: [String]) {

        for eachDistractor in distractorArray {

            if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {

                self.cantoPopDistractorMO = CantoPopDistractorMO(context: appDelegate.persistentContainer.viewContext)

                self.cantoPopDistractorMO.distractorStr = eachDistractor

                print("你存入了 \(eachDistractor) 在 Cantonese Distractor CoreData 中")

                appDelegate.saveContext()
            }
        }

    }

}
