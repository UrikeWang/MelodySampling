//
//  NewTypeChooseViewController.swift
//  MelodySampling
//
//  Created by moon on 2017/8/11.
//  Copyright © 2017年 Marvin Lin. All rights reserved.
//

import UIKit
import Alamofire
import Firebase

class NewTypeChooseViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var ref: DatabaseReference!
    
    var typeList = ["男歌手", "女歌手", "團體歌手", "單人歌手"]
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func playButtonTapped(_ sender: UIButton) {
        
        print("開始抓題庫了")
        
        self.ref = Database.database().reference()
        
        ref.child("questionBanks").child("mandarin").child("genreCod1").child("question1").queryOrderedByKey().observeSingleEvent(of: .value, with: { (snapshot) in
            
            guard let postDict = snapshot.value as? [String: AnyObject] else { return }
            
            print(snapshot)
            
            let indexArray = Array(postDict.keys)
            
            guard let songsList = [postDict[indexArray[0]]!["previewUrl"]!, postDict[indexArray[1]]!["previewUrl"]!, postDict[indexArray[2]]!["previewUrl"]!, postDict[indexArray[3]]!["previewUrl"]!, postDict[indexArray[4]]!["previewUrl"]!] as? [String] else { return }
            
            for index in 0..<songsList.count {
                
                let eachSong = songsList[index]
                
                let destination: DownloadRequest.DownloadFileDestination = { _, _ in
                    let documentsURL = NSHomeDirectory() + "/Documents/"
                    let fileURL = URL(fileURLWithPath: documentsURL.appending("song\(index).m4a"))
                    print("song\(index).m4a is downloading")
                    
                    return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
                }
                
                DispatchQueue.main.async {
                    Alamofire.download(eachSong, to: destination).response { _ in
                        
                        //                    print(response.response)
                    }
                    
                }
            }
        })
    }
    
    @IBAction func checkButtonTapped(_ sender: UIButton) {
        
        let fileManager = FileManager()
        
        do {
            let fileList = try fileManager.contentsOfDirectory(atPath: NSHomeDirectory() + "/Documents/")
            
            for file in fileList {
                print(file)
            }
        } catch {
            print("Something wrong during loading")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        
        tableView.dataSource = self
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return typeList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "TypeCell"
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        
        cell.textLabel?.text = typeList[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return self.tableView.frame.height / CGFloat(typeList.count)
        
    }
}
