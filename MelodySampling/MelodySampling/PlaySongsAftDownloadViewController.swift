//
//  PlaySongsAftDownloadViewController.swift
//  MelodySampling
//
//  Created by moon on 2017/8/2.
//  Copyright © 2017年 Marvin Lin. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySongsAftDownloadViewController: UIViewController {

    var player: AVAudioPlayer?

    let path: String = NSHomeDirectory() + "/Documents/"

    @IBAction func playSon0Tapped(_ sender: UIButton) {

        let fileName = self.path + "song0.m4a"

        player?.pause()

        do {
            player = try AVAudioPlayer(contentsOf: URL(string: fileName)!)
        } catch {
            player = nil
        }
        player?.play()

    }

    @IBAction func playSong1Tapped(_ sender: UIButton) {

        let fileName = self.path + "song1.m4a"

        player?.pause()

        do {
            player = try AVAudioPlayer(contentsOf: URL(string: fileName)!)
        } catch {
            player = nil
        }
        player?.play()

    }

    @IBAction func playSong2Tapped(_ sender: UIButton) {

        let fileName = self.path + "song2.m4a"

        player?.pause()

        do {
            player = try AVAudioPlayer(contentsOf: URL(string: fileName)!)
        } catch {
            player = nil
        }
        player?.play()

    }

    @IBAction func playSong3Tapped(_ sender: UIButton) {

        let fileName = self.path + "song3.m4a"

        player?.pause()

        do {
            player = try AVAudioPlayer(contentsOf: URL(string: fileName)!)
        } catch {
            player = nil
        }
        player?.play()
    }

    @IBAction func playSong4Tapped(_ sender: UIButton) {

        let fileName = self.path + "song4.m4a"

        player?.pause()

        do {
            player = try AVAudioPlayer(contentsOf: URL(string: fileName)!)
        } catch {
            player = nil
        }
        player?.play()

    }

    @IBAction func playSong5Tapped(_ sender: UIButton) {

        let fileName = self.path + "song5.m4a"

        player?.pause()

        do {
            player = try AVAudioPlayer(contentsOf: URL(string: fileName)!)
        } catch {
            player = nil
        }
        player?.play()
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
