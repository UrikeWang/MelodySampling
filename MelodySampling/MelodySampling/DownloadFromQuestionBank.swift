//
//  DownloadFromQuestionBank.swift
//  MelodySampling
//
//  Created by moon on 2017/8/12.
//  Copyright © 2017年 Marvin Lin. All rights reserved.
//

import UIKit
import Foundation
import Alamofire
import Firebase
import UICircularProgressRing
import CoreData
import SwiftyJSON

class DownloadManager {
    
    var ref: DatabaseReference!
    var questionMO: QuestionMO!
    var questionArray = [EachQuestion]()
    let userDefault = UserDefaults.standard
    private let downloadQueue = DispatchQueue(label: "downloading")

    func downloadRandomQuestion(selected language: String, max bankMaxNumber: Int, viewController thisController: UIViewController) {
        
        var downloadCount = 0
        
        var downloadPercentage: Double = 0
        
        // MARK: Init the question array of Navigation here
        let selfNavigation = thisController.navigationController as? PlayingNavigationController
        
        selfNavigation?.questionArray = [EachQuestion]()
        selfNavigation?.distractorArray = [String]()
        print("questionArray in navigation was inited")
        print("目標題庫是 \(language)")
        
        
        let progressContentView = UIView(frame: CGRect(
            x: 0,
            y: 0,
            width: thisController.view.frame.width,
            height: thisController.view.frame.height))
        
        createProgressBackground(target: progressContentView)
        
        // progress view starts from here
        let progressRing = UICircularProgressRingView(frame: CGRect(
            x: thisController.view.frame.width / 2 - 120,
            y: thisController.view.frame.height / 2 - 120,
            width: 240,
            height: 240))
        
        progressRing.maxValue = 100
        
        progressRing.outerRingColor = UIColor.mldDarkIndigo40
        progressRing.innerRingColor = UIColor.mldUltramarine
        
        // progress view ends here
        
        progressContentView.backgroundColor = UIColor.playPageBackground
        
        progressContentView.insertSubview(progressRing, at: 1)
        
        thisController.view.addSubview(progressContentView)
        
        // MARK: Download starting time for Google analytic
        let downloadStartTime = Date().timeIntervalSince1970
        
        for counter in 0..<5 {
            
            let trackIndex = random(bankMaxNumber)
            
            let finder = "track" + String(trackIndex)
            
            ref = Database.database().reference()
            
            ref.child("questionBanks").child(language).child("allList").child(finder).queryOrderedByKey().observeSingleEvent(of: .value, with: { (snapshot) in
                
                let json = JSON(snapshot.value as Any)
                
                print("======")
                print(json["artistId"].intValue)
                print(json["artistName"].stringValue)
                print(json["trackId"].intValue)
                print(json["trackName"].stringValue)
                print(json["artworkUrl100"].stringValue)
                print(json["previewUrl"].stringValue)
                print(json["collectionId"].intValue)
                print(json["collectionName"].stringValue)
                print(json["primaryGenreName"].stringValue)
                print(counter)
                
                // MARK: Save EachQuestion to navigation bar
                
                let eachQuestion = EachQuestion(
                    artistID: json["artistId"].intValue,
                    artistName: json["artistName"].stringValue,
                    trackID: json["trackId"].intValue,
                    trackName: json["trackName"].stringValue,
                    artworkUrl: json["artworkUrl100"].stringValue,
                    previewUrl: json["previewUrl"].stringValue,
                    collectionID: json["collectionId"].intValue,
                    collectionName: json["collectionName"].stringValue,
                    primaryGenreName: json["primaryGenreName"].stringValue
                )
                
                selfNavigation?.questionArray.append(eachQuestion)
                
                //這個 QuestionMO 要拿掉
                if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
                    
                    self.questionMO = QuestionMO(context: appDelegate.persistentContainer.viewContext)
                    
                    self.questionMO.indexNo = Int16(counter)
                    self.questionMO.artistID = String(eachQuestion.artistID)
                    self.questionMO.artistName = eachQuestion.artistName
                    self.questionMO.trackID = String(eachQuestion.trackID)
                    self.questionMO.trackName = eachQuestion.trackName
                    self.questionMO.artworkUrl = eachQuestion.artworkUrl
                    self.questionMO.previewUrl = eachQuestion.previewUrl
                    self.questionMO.collectionID = String(eachQuestion.collectionID)
                    self.questionMO.collectionName = eachQuestion.collectionName
                    self.questionMO.primaryGenreName = eachQuestion.primaryGenreName
                    
                    appDelegate.saveContext()
                }
                
                let destination: DownloadRequest.DownloadFileDestination = { _, _ in
                    let documentsURL = NSHomeDirectory() + "/Documents/"
                    let pathName = "song" + String(counter) + ".m4a"
                    let fileURL = URL(fileURLWithPath: documentsURL.appending(pathName))
                    
                    let fileManager = FileManager.default
                    
                    do {
                        try fileManager.removeItem(at: fileURL)
                        print("song\(counter).m4a was deleted")
                    } catch {
                        print("song\(counter).m4a is not exist")
                    }
                    
                    print("song\(counter).m4a is downloading")
                    
                    return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
                }
                
                let distractorManager = DistractorManager()
                
                _ = distractorManager.getDistractorIDArray(distractorArrayCount: 40, distractorBankCount: 1200, genre: language, controller: thisController)
                
                Alamofire.download(eachQuestion.previewUrl, to: destination).downloadProgress { progress in
                    
                    // The progress status muse be removed
                    
                    self.downloadQueue.sync {
                        
                        if downloadPercentage < 80 {
                            
                            downloadPercentage += progress.fractionCompleted
                        
                        } else {
                        
                            downloadPercentage += 1
                        
                        }
                        
                        progressRing.setProgress(value: CGFloat(downloadPercentage), animationDuration: 0.01) {}
                    }
                    
                    }.response { _ in
                        
                        downloadCount += 1
                        
                        if downloadCount == 5 {
                            
                            progressRing.setProgress(value: CGFloat(100), animationDuration: 0.01) {
                                
                                // MARK: Timepassed for Google analytics
                                let downloadPassedTime = Date().timeIntervalSince1970 - downloadStartTime
                                
                                Analytics.logEvent("DownloadTime", parameters: [language: downloadPassedTime as NSObject, "DownloadPassedTime": downloadPassedTime as NSObject])
                                
                                //                                    thisController.present(registerVC!, animated: true, completion: nil)
                                
                                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                
                                let destinationViewController = storyboard.instantiateViewController(withIdentifier: "PlayPage")
                                thisController.navigationController?.pushViewController(destinationViewController, animated: true)
                                
                                let delayTime = DispatchTime.now() + .seconds(1)
                                
                                DispatchQueue.main.asyncAfter(deadline: delayTime, execute: {
                                    progressContentView.removeFromSuperview()
                                })
                                
                            }
                        }
                }
            })
        }
    }
    
    func getCounter() {
        ref = Database.database().reference()
        
        ref.child("questionCounter").observeSingleEvent(of: .value, with: { (snapshot) in
            
            print(snapshot)
            
            let json = JSON(snapshot.value as Any)
            
            print("JSON raw value: \(json)")
            
            let questionCounter = json.intValue
            
            print("目前歌曲數為 : \(questionCounter)")
            
            self.userDefault.set(questionCounter, forKey: "questionCounter")
            
        })
    }
}
