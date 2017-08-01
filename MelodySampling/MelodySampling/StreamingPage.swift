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
import CoreMedia

class StreamingPage: UIViewController {

    var ref: DatabaseReference!

    var playerItems = [
        AVPlayerItem(url: URL(string: testSong0)!),
        AVPlayerItem(url: URL(string: testSong1)!),
        AVPlayerItem(url: URL(string: testSong2)!),
        AVPlayerItem(url: URL(string: testSong3)!),
        AVPlayerItem(url: URL(string: testSong4)!)]

    var currentTrack = 0

//        [AVPlayerItem(url: url1), AVPlayerItem(url: url2), AVPlayerItem(url: url3), AVPlayerItem(url: url4), AVPlayerItem(url: url5)]

    var player = AVQueuePlayer()

    @IBAction func button1Tapped(_ sender: UIButton) {
        currentTrack = 0
        player.replaceCurrentItem(with: playerItems[currentTrack])

        player.play()
    }

    @IBAction func button2Tapped(_ sender: UIButton) {
        currentTrack = 1

        player.replaceCurrentItem(with: playerItems[currentTrack])
        player.play()
    }

    @IBAction func button3Tapped(_ sender: UIButton) {
        currentTrack = 2

        player.replaceCurrentItem(with: playerItems[currentTrack])
        player.play()
    }

    @IBAction func button4Tapped(_ sender: UIButton) {
        currentTrack = 3

        player.replaceCurrentItem(with: playerItems[currentTrack])
        player.play()
    }

    @IBAction func button5Tapped(_ sender: UIButton) {
        currentTrack = 4

        player.replaceCurrentItem(with: playerItems[currentTrack])
        player.play()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        getDeveloperToken()

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
