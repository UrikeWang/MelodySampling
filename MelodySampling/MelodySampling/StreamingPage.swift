//
//  StreamingPage.swift
//  MelodySampling
//
//  Created by moon on 2017/7/31.
//  Copyright © 2017年 Marvin Lin. All rights reserved.
//

import UIKit
import Firebase

class StreamingPage: UIViewController {

    var ref: DatabaseReference!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.ref = Database.database().reference()

        print("Starting observe")

        self.ref.child("tokens").child("developerToken").child("token").observe(.value, with: { (snapshot) in

            print(snapshot.value)
            print(type(of: snapshot.value!))

        }) { (error) in
            print(error.localizedDescription)

        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
