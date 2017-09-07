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

protocol DistractorManagerDelegate: class {

    func manager(_ manager: DistractorManager, didGet distractors: [String])
    func manager(_ manager: DistractorManager, didFailWith error: Error)
}

class DistractorManager {

    var distractorMO: DistractorMO!

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

            let json = JSON(snapshot.value as Any)

//            print("歌名: \(json[randomStr].stringValue)")

            self.distractors.append(json[randomStr].stringValue)

            if self.distractors.count == self.saveContextTrigger {

                self.saveDistractors(input: self.distractors)

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

        for eachDistractorID in returnArray {

            getOneDistractor(input: eachDistractorID, genre: genreInput)
        }
    }

    func saveDistractors(input distractorArray: [String]) {

        for eachDistractor in distractorArray {

            if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {

                self.distractorMO = DistractorMO(context: appDelegate.persistentContainer.viewContext)

                self.distractorMO.distractorStr = eachDistractor

                appDelegate.saveContext()
            }
        }
    }

}
