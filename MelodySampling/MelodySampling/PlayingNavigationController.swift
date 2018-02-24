//
//  PlayingNavigationController.swift
//  King of Song Quiz
//
//  Created by moon on 2017/10/19.
//  Copyright © 2017年 Marvin Lin. All rights reserved.
//

import UIKit
import Firebase

class PlayingNavigationController: UINavigationController {

    var questionArray = [EachQuestion]()
    var resultArray = [ResultToShow]()
    var distractorArray = [String]()
    var randomUser: RandomUser.Results?
    var randomUserImage = UIImage()
    var ref: DatabaseReference!
    var unixTimestamp: Double?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.ref = Database.database().reference()
        let timePath = ref.child("currentTime")
        let timeDict = ["timestamp": ServerValue.timestamp()] as [String: Any]
        timePath.updateChildValues(timeDict)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.ref = Database.database().reference()
        let timePath = ref.child("currentTime")
        
        timePath.observe( .value, with: { (snapshot) in
            guard let value = snapshot.value as? [String: Any],
                let timestamp = value["timestamp"] as? Double else { return }
            
            self.unixTimestamp = timestamp / 1000
            let date = Date(timeIntervalSince1970: self.unixTimestamp!)
            let strDate = DateUtility.getStrDate(from: date)
            let weekOfYear = DateUtility.getWeekOfYear(from: date)
            
            print("目前聽到的時間: \(timestamp)")
            print("轉換後的時間: \(strDate)")
            print("週數: \(weekOfYear)")
        }) { (err) in
            print("error :\(err)")
        }
        
    }
}
