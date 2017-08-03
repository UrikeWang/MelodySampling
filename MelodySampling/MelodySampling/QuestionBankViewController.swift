//
//  QuestionBankViewController.swift
//  MelodySampling
//
//  Created by moon on 2017/8/3.
//  Copyright © 2017年 Marvin Lin. All rights reserved.
//

import UIKit
import Firebase

class QuestionBankViewController: UIViewController {

    @IBOutlet weak var resultLabel: UILabel!

    var ref: DatabaseReference!

    @IBAction func chooseButtonTapped(_ sender: UIButton) {

        print("開始抓題庫了")

        self.ref = Database.database().reference()

        ref.child("questionBanks").child("mandarin").child("genreCod1").child("question1").queryOrderedByKey().queryLimited(toFirst: 5).observeSingleEvent( of: .value, with: {
            (snapshot) in

//            print(snapshot)
            print("有印 snapshot")
            
            let postDict = snapshot.value as? [String: AnyObject] ?? [:]
            
            let dict0 = postDict["41641840"] as? [String: AnyObject] ?? [:]

            let artist0 = dict0["artistName"]! as Any
            let song0 = dict0["trackName"]! as Any
            
            let dict1 = postDict["405896104"] as? [String: AnyObject] ?? [:]
            
            let artist1 = dict1["artistName"]! as Any
            let song1 = dict1["trackName"]! as Any

            let dict2 = postDict["542922095"] as? [String: AnyObject] ?? [:]
            
            let artist2 = dict2["artistName"]! as Any
            let song2 = dict2["trackName"]! as Any
            
            let dict3 = postDict["910065949"] as? [String: AnyObject] ?? [:]
            
            let artist3 = dict3["artistName"]! as Any
            let song3 = dict3["trackName"]! as Any
            
            let dict4 = postDict["910065956"] as? [String: AnyObject] ?? [:]
            
            let artist4 = dict4["artistName"]! as Any
            let song4 = dict4["trackName"]! as Any
            
            let string = "第一個歌手: \(artist0) 第一首: \(song0) \n第二個歌手: \(artist1) 第二首: \(song1)\n第三個歌手:\(artist2) 第三首: \(song2)\n 第四個歌手: \(artist3) 第四首: \(song3)\n 第五個歌手: \(artist4) 第五首: \(song4)"
            
            self.resultLabel.text = string

        }

        )
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
