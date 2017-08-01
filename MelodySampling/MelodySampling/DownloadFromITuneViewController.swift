//
//  DownloadFromITuneViewController.swift
//  MelodySampling
//
//  Created by moon on 2017/8/1.
//  Copyright © 2017年 Marvin Lin. All rights reserved.
//

import UIKit
import Alamofire
import AVFoundation
import MediaPlayer

class DownloadFromITuneViewController: UIViewController, MPMediaPickerControllerDelegate {

    var player: AVAudioPlayer?

    var destinationTest: NSURL?

    var fileName: String?

    var finalPath: NSURL?

    let fm: FileManager = FileManager()

    let path: String = NSHomeDirectory() + "/tmp/"

    @IBAction func button1Tapped(_ sender: UIButton) {
    }

    @IBAction func button2Tapped(_ sender: UIButton) {
    }

    @IBAction func button3Tapped(_ sender: UIButton) {
    }

    @IBAction func button4Tapped(_ sender: UIButton) {
    }

    @IBAction func button5Tapped(_ sender: UIButton) {
    }

    @IBAction func startingDownloadTapped(_ sender: UIButton) {

        let destination = DownloadRequest.suggestedDownloadDestination()

//        let destinationString: String = NSHomeDirectory() + "/Documents/song1.m4a"

//        let destination = URL(string: destinationString)

        Alamofire.download(testSong5, to: destination).response { response in // method defaults to `.get`
//            print(response.request)
//            print(response.response)
//            print(response.temporaryURL)
//            print(response.destinationURL)
//            print(response.error)

            self.fileName = response.response?.suggestedFilename

            self.finalPath = response.destinationURL as? NSURL
        }
    }

    @IBAction func checkFileExist(_ sender: UIButton) {

        let path: String = NSHomeDirectory() + "/Documents/"

        let fileName = path + self.fileName!

//        print(fm.fileExists(atPath: fileName))

        let existBool = fm.fileExists(atPath: fileName)

        print("Result \(existBool)")

        let playerItems = AVPlayerItem(url: URL(string: fileName)!)

        print(playerItems)
        print(type(of: playerItems))

//        player = AVPlayer(playerItem: playerItems)

//        player?.play()

        do {

            player = try AVAudioPlayer(contentsOf: URL(string: fileName)!)

            var audioSession = AVAudioSession.sharedInstance()

            do {
                try audioSession.setCategory(AVAudioSessionCategoryPlayback)
            } catch {

            }

        } catch {
            print(error)
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

    func mediaPickerDidCancel(_ mediaPicker: MPMediaPickerController) {
        dismiss(animated: true, completion: nil)

    }

    func mediaPicker(_ mediaPicker: MPMediaPickerController, didPickMediaItems mediaItemCollection: MPMediaItemCollection) {
        let musicPlayer = MPMusicPlayerController.applicationMusicPlayer()
        musicPlayer.play()
        musicPlayer.setQueue(with: mediaItemCollection)

        dismiss(animated: true, completion: nil)
    }

}
