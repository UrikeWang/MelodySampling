//
//  StreamingPage.swift
//  MelodySampling
//
//  Created by moon on 2017/7/31.
//  Copyright © 2017年 Marvin Lin. All rights reserved.
//

import UIKit
import Firebase
import AVFoundation

class StreamingPage: UIViewController {

    var ref: DatabaseReference!

    var player: AVPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getDeveloperToken()
        
        print("開始下載了")
        let url1 = URL(string: testSong1)
        let playerItem: AVPlayerItem = AVPlayerItem(url: url1!)
        player = AVPlayer(playerItem: playerItem)
        player?.play()

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
