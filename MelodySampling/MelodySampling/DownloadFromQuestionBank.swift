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

    func downloadQuestion(selected language: String, genre code: Int, viewController thisView: UIViewController) {

        let genreCode = "genreCode" + String(code)

        var downloadCount = 0

        print("目標題庫是 \(genreCode)")

        let progressContentView = UIView(frame: CGRect(x: 0, y: 0, width: thisView.view.frame.width, height: thisView.view.frame.height))

        let progressRing = UICircularProgressRingView(frame: CGRect(x: thisView.view.frame.width / 2 - 120, y: thisView.view.frame.height / 2 - 120, width: 240, height: 240))

        progressRing.maxValue = 100

        progressRing.outerRingColor = UIColor.green

        progressRing.innerRingColor = UIColor.blue

        progressContentView.backgroundColor = UIColor.white

        progressContentView.addSubview(progressRing)

        thisView.view.addSubview(progressContentView)

        ref = Database.database().reference()

        ref.child("questionBanks").child(language).child(genreCode).child("question1").queryOrderedByKey().observeSingleEvent(of: .value, with: { (snapshot) in

            guard let postDict = snapshot.value as? [String: AnyObject] else { return }

            let indexArray = Array(postDict.keys) //每一個裡面都是 trackID

            var counter = 0

            for eachTrackID in indexArray {

                let eachQuestion = EachQuestion(
                    artistID: (postDict[eachTrackID]?["artistId"] as? Int)!,
                    artistName: (postDict[eachTrackID]?["artistName"] as? String)!,
                    trackID: (postDict[eachTrackID]?["trackId"] as? Int)!,
                    trackName: (postDict[eachTrackID]?["trackName"] as? String)!,
                    artworkUrl: (postDict[eachTrackID]?["artworkUrl100"] as? String)!,
                    previewUrl: (postDict[eachTrackID]?["previewUrl"] as? String)!,
                    collectionID: (postDict[eachTrackID]?["collectionId"] as? Int)!,
                    collectionName: (postDict[eachTrackID]?["collectionName"] as? String)!,
                    primaryGenreName: (postDict[eachTrackID]?["primaryGenreName"] as? String)!)

                self.questionArray.append(eachQuestion)

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

//                print("\(eachQuestion.artistName) is appended")
                print("==== Type Genre Page =====")
                print("第 \(counter) 個是 \(eachQuestion.artistName), trackID: \(eachQuestion.trackID), artistID: \(eachQuestion.artistID)")
                counter += 1

            }

            var downloadPercentage: Double = 0

            for index in 0..<self.questionArray.count {

                let eachSong = self.questionArray[index].previewUrl

                let destination: DownloadRequest.DownloadFileDestination = { _, _ in
                    let documentsURL = NSHomeDirectory() + "/Documents/"
                    let fileURL = URL(fileURLWithPath: documentsURL.appending("song\(index).m4a"))
                    print("song\(index).m4a is downloading")
                    print("ArtistName: \(self.questionArray[index].artistName), trackName: \(self.questionArray[index].trackName), trackID: \(self.questionArray[index].trackID)")

                    return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
                }

                let distractorManager = DistractorManager()

                _ = distractorManager.getDistractorIDArray(distractorArrayCount: 40, distractorBankCount: 400, genre: language)

                Alamofire.download(eachSong, to: destination).downloadProgress { progress in

                    if downloadPercentage < 80 {
                        downloadPercentage += progress.fractionCompleted * 2
                    } else {
                        downloadPercentage += 1
                    }

                    progressRing.setProgress(value: CGFloat(downloadPercentage), animationDuration: 0.01) {}

                    }.response { _ in

                    downloadCount += 1
                    print("第 \(downloadCount) 首下載完成")

                    if downloadCount == self.questionArray.count {

                        progressRing.setProgress(value: CGFloat(downloadCount * 20), animationDuration: 0.01) {

                            let registerVC = thisView.storyboard?.instantiateViewController(withIdentifier: "PlayPage")

                            thisView.present(registerVC!, animated: true, completion: nil)
                        }

                    }
                }

                let artworkDestination: DownloadRequest.DownloadFileDestination = { _, _ in

                    let documentsURL = NSHomeDirectory() + "/Documents/"
                    let artworkFileURL = URL(fileURLWithPath: documentsURL.appending("artworkImage\(index).jpg"))

                    return (artworkFileURL, [.removePreviousFile, .createIntermediateDirectories])

                }

                let artworkUrl = self.questionArray[index].artworkUrl

                Alamofire.download(artworkUrl, to: artworkDestination).response { _ in

                }
            }
        })
    }

    func getCounter() {
        ref = Database.database().reference()

        ref.child("questionCounter").observeSingleEvent(of: .value, with: { (snapshot) in

            print(snapshot)

            let json = JSON(snapshot.value)

            print("JSON raw value: \(json)")

            let questionCounter = json.intValue

            print("目前歌曲數為 : \(questionCounter)")

            self.userDefault.set(questionCounter, forKey: "questionCounter")

        })
    }
}
