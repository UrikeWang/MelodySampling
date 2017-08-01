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

class DownloadFromITuneViewController: UIViewController {

    var destinationTest: NSURL?
    
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

        print("I save a file in text1.txt")

        let fileName = path + "mzaf_8018084475304913012.m4a"

//        fm.createFile(atPath: fileName, contents: nil, attributes: nil)
        let documentsURL: URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first as URL!
        let destinationFileURL = documentsURL.appendingPathComponent("song0.m4a")

        let fileURL = URL(string: testSong0)

        let sessionConfig = URLSessionConfiguration.default

        let session = URLSession(configuration: sessionConfig)

        let request = URLRequest(url: fileURL!)
        
        var localPath: NSURL?
        
        let destination = DownloadRequest.suggestedDownloadDestination()
        Alamofire.download(testSong0, to: destination).validate().responseData { (response) in
            debugPrint(response)
            print(response.temporaryURL)
            print(response.destinationURL)
            
            self.destinationTest = response.destinationURL as! NSURL
        }

    }

    @IBAction func checkFileExist(_ sender: UIButton) {

        let fileName = self.destinationTest

//        print(fm.fileExists(atPath: fileName))
        
//        let existBool = fm.fileExists(atPath: fileName)
        
        print("Result \(existBool)")
        
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
