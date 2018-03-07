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

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
