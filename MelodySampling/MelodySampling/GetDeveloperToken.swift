//
//  GetDeveloperToken.swift
//  MelodySampling
//
//  Created by moon on 2017/7/31.
//  Copyright © 2017年 Marvin Lin. All rights reserved.
//

import Foundation
import Firebase

func getDeveloperToken() {

    var ref: DatabaseReference!

    ref = Database.database().reference()

    ref.child("tokens").child("developerToken").child("token").observe(.value, with: { (snapshot) in

        // TODO: 這一部分是要連動 Apple music 目前沒這功能

        guard let devToken = snapshot.value
            else {
            print("Your server don't have developer token")
            return
        }

        let userDefault = UserDefaults.standard

        userDefault.set(devToken, forKey: "devToken")

    }) { (error) in
        print(error.localizedDescription)

    }

}
