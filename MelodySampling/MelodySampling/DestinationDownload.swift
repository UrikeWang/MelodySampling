//
//  DestinationDownload.swift
//  MelodySampling
//
//  Created by moon on 2017/8/1.
//  Copyright © 2017年 Marvin Lin. All rights reserved.
//

import UIKit
import Alamofire

//開始改 fileURL
class DestinationDownload: UIViewController {

    @IBOutlet weak var containFielLabel: UILabel!

    @IBOutlet weak var resultLabel: UILabel!

    @IBAction func startButtonTapped(_ sender: UIButton) {

        let destinationString = NSHomeDirectory() + "/Documents/" + "song1.m4a"
//        let destination = URL(fileURLWithPath: destinationString)

        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
            let documentsURL = NSHomeDirectory() + "/Documents/"
            let fileURL = URL(fileURLWithPath: documentsURL.appending("song2.m4a"))

            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }

        Alamofire.download(testSong1, to: destination).response { response in

            print(response.response)
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
