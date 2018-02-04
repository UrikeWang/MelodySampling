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

    override func viewDidLoad() {
        super.viewDidLoad()

        self.ref = Database.database().reference()
        let timePath = ref.child("currentTime")
        let timeDict = ["timestamp": ServerValue.timestamp()] as [String: Any]
        timePath.updateChildValues(timeDict)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.ref = Database.database().reference()
        let timePath = ref.child("currentTime")
        timePath.observeSingleEvent(of: .value, with: { (snapshot) in
            // FIXME: 聽到的日期是放在之後的比賽裡面
            guard let value = snapshot.value as? [String: Any],
                let timestamp = value["timestamp"] else { return }
            print("目前聽到的時間: \(timestamp)")

        }) { (err) in
            print("error :\(err)")
        }
    }
}
