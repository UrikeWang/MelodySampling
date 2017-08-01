//
//  DestinationDownload.swift
//  MelodySampling
//
//  Created by moon on 2017/8/1.
//  Copyright © 2017年 Marvin Lin. All rights reserved.
//

import UIKit
import Alamofire

class DestinationDownload: UIViewController {

    @IBOutlet weak var containFielLabel: UILabel!
    
    @IBOutlet weak var resultLabel: UILabel!
    
    @IBAction func startButtonTapped(_ sender: UIButton) {
        
        
        
    }
    
    @IBAction func checkButtonTapped(_ sender: UIButton) {
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let tempDirectory = NSTemporaryDirectory()
        resultLabel.text = "\(tempDirectory)"
        
        print(tempDirectory)
        
        let fileManager = FileManager()
        
        do {
            let fileList = try fileManager.contentsOfDirectory(atPath: NSTemporaryDirectory())
            
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
