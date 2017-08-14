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

class DownloadManager {

    var ref: DatabaseReference!

    var questionMO: QuestionMO!

    var questionArray = [EachQuestion]()

    func downloadQuestion(genre code: Int, viewController thisView: UIViewController) {

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

        ref.child("questionBanks").child("mandarin").child(genreCode).child("question1").queryOrderedByKey().observeSingleEvent(of: .value, with: { (snapshot) in

            guard let postDict = snapshot.value as? [String: AnyObject] else { return }

            let indexArray = Array(postDict.keys) //每一個裡面都是 trackID

            //從這一段開始改寫接把每一個東西倒進 EachQuestion

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

                    self.questionMO.artistID = String(eachQuestion.artistID)
                    self.questionMO.artistName = eachQuestion.artistName
                    self.questionMO.trackID = String(eachQuestion.trackID)
                    self.questionMO.trackName = eachQuestion.trackName
                    self.questionMO.artworkUrl = eachQuestion.artworkUrl
                    self.questionMO.previewUrl = eachQuestion.previewUrl
                    self.questionMO.collectionID = String(eachQuestion.collectionID)
                    self.questionMO.collectionName = eachQuestion.artistName
                    self.questionMO.primaryGenreName = eachQuestion.primaryGenreName

                    appDelegate.saveContext()
                }

                print("\(eachQuestion.artistName) is appended")

            }

            for index in 0..<self.questionArray.count {

                let eachSong = self.questionArray[index].previewUrl

                let destination: DownloadRequest.DownloadFileDestination = { _, _ in
                    let documentsURL = NSHomeDirectory() + "/Documents/"
                    let fileURL = URL(fileURLWithPath: documentsURL.appending("song\(index).m4a"))
                    print("song\(index).m4a is downloading")

                    return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
                }

                DispatchQueue.main.async {
                    Alamofire.download(eachSong, to: destination).response { _ in

                        downloadCount += 1
                        print("第 \(downloadCount) 首下載完成")

                        if downloadCount == self.questionArray.count {

                            progressRing.setProgress(value: CGFloat(downloadCount * 20), animationDuration: 0.01) {

                                let registerVC = thisView.storyboard?.instantiateViewController(withIdentifier: "PlayPage")

                                thisView.present(registerVC!, animated: true, completion: nil)
                            }

                        } else {
                            progressRing.setProgress(value: CGFloat(downloadCount * 20 ), animationDuration: 0.01) {}
                        }
                    }
                }
            }
        })
    }
}
