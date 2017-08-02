//
//  DestinationDownload.swift
//  MelodySampling
//
//  Created by moon on 2017/8/1.
//  Copyright © 2017年 Marvin Lin. All rights reserved.
//

import UIKit
import Alamofire
import AVFoundation

//開始改 fileURL
class DestinationDownload: UIViewController {

    var player: AVAudioPlayer?

    @IBOutlet weak var containFielLabel: UILabel!

    @IBOutlet weak var resultLabel: UILabel!

    @IBAction func startButtonTapped(_ sender: UIButton) {

//        let destinationString = NSHomeDirectory() + "/Documents/" + "song1.m4a"
//        let destination = URL(fileURLWithPath: destinationString)

        

        let songsList = [testSong0, testSong1, testSong2, testSong3, testSong4, testSong5]
        
        for eachSong in songsList {
            
            let index = String(describing: songsList.index(of: eachSong)!)
            
            let destination: DownloadRequest.DownloadFileDestination = { _, _ in
                let documentsURL = NSHomeDirectory() + "/Documents/"
                let fileURL = URL(fileURLWithPath: documentsURL.appending("song" + index + ".m4a"))
                print("song\(index).m4a is downloading")
                
                return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
            }
            
            Alamofire.download(eachSong, to: destination).response { response in
                
                print(response.response)
            }

        }
    }

    @IBAction func checkButtonTapped(_ sender: UIButton) {

        let fileManager = FileManager()

        do {
            let fileList = try fileManager.contentsOfDirectory(atPath: NSHomeDirectory() + "/Documents/")

            containFielLabel.text = "\(fileList)"

            for file in fileList {
                print(file)
            }
        } catch {
            print("Something wrong during loading")
        }

    }

    @IBAction func clearButton(_ sender: UIButton) {

        let fileManager = FileManager()

        do {
            let fileList = try fileManager.contentsOfDirectory(atPath: NSHomeDirectory() + "/Documents/")

            for file in fileList {
                do {
                    try fileManager.removeItem(atPath: NSHomeDirectory() + "/Documents/" + file) } catch {
                    print("can't delete file")
                }
            }
        } catch {
            print("can't delete file")
        }

    }

    @IBAction func playButtonTapped(_ sender: UIButton) {
        let path: String = NSHomeDirectory() + "/Documents/"

        let fileName = path + "song1.m4a"

        let playerItems = AVPlayerItem(url: URL(string: fileName)!)

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

    @IBAction func pauseButtonTapped(_ sender: UIButton) {

        player?.pause()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let docDirectory = NSHomeDirectory() + "/Documents/"
        resultLabel.text = "\(docDirectory)"

        print(docDirectory)

        let fileManager = FileManager()

        do {
            let fileList = try fileManager.contentsOfDirectory(atPath: NSHomeDirectory() + "/Documents/")

            containFielLabel.text = "\(fileList)"

            for file in fileList {
                print(file)
            }
        } catch {
            print("Something wrong during loading")
        }

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
