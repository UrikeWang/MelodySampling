//
//  UpdateManager.swift
//  MelodySampling
//
//  Created by moon on 2017/9/2.
//  Copyright © 2017年 Marvin Lin. All rights reserved.
//

import Foundation
import Firebase

class UpdateManager {
    
    var ref: DatabaseReference!
    
    func updateUserName(_ uid: String, update rename: String) {
        
        ref = Database.database().reference()
        
        ref.child("anonymousUsers").child(uid).updateChildValues(["fullName" : rename])
        
    }
    
}
