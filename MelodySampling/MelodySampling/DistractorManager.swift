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
    
    func getOneDistractor(input random: Int, genre genreInput: String, controller thisController: UIViewController) {
        
        ref = Database.database().reference()
        
        let randomStr = "distractor" + String(random)
        
        ref.child("distractorBanks").child(genreInput).child("allList").queryOrderedByKey().queryEqual(toValue: randomStr).observeSingleEvent(of: .value, with: { (snapshot) in
            
            let json = JSON(snapshot.value as Any)
            
            //            print("歌名: \(json[randomStr].stringValue)")
            
            self.distractors.append(json[randomStr].stringValue)
            
            if self.distractors.count == self.saveContextTrigger {
                
                self.saveDistractors(input: self.distractors)
                
                let selfNavigation = thisController.navigationController as? PlayingNavigationController
                
                selfNavigation?.distractorArray = self.distractors
                
                print("====== navigation distractors ======")
                print(selfNavigation?.distractorArray)
            }
        })
    }
    
    // MARK: Revising here after dinner, distractors array
    func getDistractorIDArray(distractorArrayCount count: Int, distractorBankCount bankMax: Int, genre genreInput: String, controller thisController: UIViewController) {
        
        self.distractors = []
        
        self.saveContextTrigger = count
        
        var returnArray = [Int]()
        
        while returnArray.count != count {
            
            let distractorID = random(bankMax)
            
            if !returnArray.contains(distractorID) {
                returnArray.append(distractorID)
            }
        }
        
        distractorIDArray = returnArray
        
        for eachDistractorID in returnArray {
            
            getOneDistractor(input: eachDistractorID, genre: genreInput, controller: thisController)
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
