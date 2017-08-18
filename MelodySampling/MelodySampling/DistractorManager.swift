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

    var ref: DatabaseReference!
    
    var distractors = [String]()
    
    weak var delegate: DistractorManagerDelegate?
    
    enum RequestDistractorsError: Error {
        
        case invalidResponse
    }

    func getOneDistractor(input random: Int, completion: @escaping (_ distracor: String) -> Void) {

        ref = Database.database().reference()

        let randomStr = "distractor" + String(random)
        ref.child("distractorBanks").child("taiwanesePop").child("allList").queryOrderedByKey().queryEqual(toValue: randomStr).observeSingleEvent(of: .value, with: { (snapshot) in

            let json = JSON(snapshot.value)

            print(json)
            print(type(of: json))

            print("歌名: \(json[randomStr].stringValue)")
        
        
            completion(json[randomStr].stringValue)

        })
    }
    
    func getDistracorsList() {
        
        var counter = 15
        
        ref = Database.database().reference()
        
        counter = 0
        
        while distractors.count != 15 {
            
            let input = random(400)
            
            getOneDistractor(input: input, completion: { result in
                self.distractors.append(result)
                
                if self.distractors.count == 15 {
                    
                    print(self.distractors)
                    
                    self.delegate?.manager(self, didGet: self.distractors)
                    
                }
                
            })
            
            
            
        }
        
    }
    

}
