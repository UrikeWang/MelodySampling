//
//  RetrieveDataViewController.swift
//  MelodySampling
//
//  Created by moon on 2017/8/2.
//  Copyright © 2017年 Marvin Lin. All rights reserved.
//

import UIKit
import Firebase

class RetrieveDataViewController: UIViewController {

    var ref: DatabaseReference!

    @IBOutlet weak var resultLabel: UILabel!

    @IBAction func startButtonTapped(_ sender: UIButton) {

        self.ref = Database.database().reference()

        //這一種方法太大，不可行
        ref.child("songs").observeSingleEvent(of: .value, with: { (snapshot) in

            print(snapshot)

            self.resultLabel.text = "\(snapshot)"

        })

    }
    
    @IBAction func only5ItemsTapped(_ sender: UIButton) {
        
        self.ref = Database.database().reference()
        
        ref.child("songs").queryOrderedByKey().queryLimited(toFirst: 6).observeSingleEvent(of: .value, with: { (snapshot) in
            print(snapshot)
            
            let postDict = snapshot.value as? [String: AnyObject] ?? [:]
            
//            print(postDict["151377160"])
            
            let insideDict = postDict["151377160"] as? [String: AnyObject] ?? [:]
            print(insideDict["artistName"] as Any)
            print(insideDict["primaryGenreName"] as Any)
            print(insideDict["collectionName"] as Any)
            print(type(of: insideDict))
        })

        
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
