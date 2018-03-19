//
//  Competitor.swift
//  King of Song Quiz
//
//  Created by Moon on 2018/3/17.
//  Copyright © 2018年 Marvin Lin. All rights reserved.
//

import Foundation
import Firebase

class Competitor: User {
    
    override func requestId() {
        
        ref = Database.database().reference()
        
        ref.child(firebaseCompetitor).queryOrderedByKey().observeSingleEvent(of: .value, with: {(snapshot) in
            
            guard let response = snapshot.value as? [String: String], let id = response["competitor1"] else { return }
            self.userId = id
            self.state = UserState.gotUserId

        })
    }
    
}
