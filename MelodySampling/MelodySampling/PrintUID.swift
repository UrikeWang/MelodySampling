//
//  PrintUID.swift
//  MelodySampling
//
//  Created by moon on 2017/8/15.
//  Copyright © 2017年 Marvin Lin. All rights reserved.
//

import Foundation

func checkUID() -> String {

    let userDefault = UserDefaults.standard

    guard let uid = userDefault.object(forKey: "uid") else { return "No uid"}

    return String(describing: uid)

}
