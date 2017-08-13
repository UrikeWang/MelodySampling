//
//  DownloadFromQuestionBank.swift
//  MelodySampling
//
//  Created by moon on 2017/8/12.
//  Copyright © 2017年 Marvin Lin. All rights reserved.
//

import Foundation
import Alamofire
import Firebase
import UICircularProgressRing

var ref: DatabaseReference!

func downloadQuestion(genre code: Int, viewController vC: UIViewController) {

    let genreCode = "genreCode\(code)"

    var downloadCount = 0

    print("目標題庫是 \(genreCode)")

    let progressContentView = UIView(frame: CGRect(x: 0, y: 0, width: vC.view.frame.width, height: vC.view.frame.height))

    let progressRing = UICircularProgressRingView(frame: CGRect(x: vC.view.frame.width / 2 - 120, y: vC.view.frame.height / 2 - 120, width: 240, height: 240))

    progressRing.maxValue = 100

    progressRing.outerRingColor = UIColor.green

    progressRing.innerRingColor = UIColor.blue

    progressContentView.backgroundColor = UIColor.white

    progressContentView.addSubview(progressRing)

    vC.view.addSubview(progressContentView)

    ref = Database.database().reference()

    ref.child("questionBanks").child("mandarin").child("\(genreCode)").child("question1").queryOrderedByKey().observeSingleEvent(of: .value, with: { (snapshot) in

        guard let postDict = snapshot.value as? [String: AnyObject] else { return }

        let indexArray = Array(postDict.keys) //每一個裡面都是 trackID

        //從這一段開始改寫接把每一個東西倒進 EachQuestion
        
        var questionArray = [EachQuestion]()
        
        for eachTrackID in indexArray {
            
            let eachQuestion = EachQuestion(artistID: (postDict[eachTrackID]?["artistId"] as? Int)!, artistName: (postDict[eachTrackID]?["artistName"] as? String)!, trackID: (postDict[eachTrackID]?["trackId"] as? Int)!, trackName: (postDict[eachTrackID]?["trackName"] as? String)!, artworkUrl30: (postDict[eachTrackID]?["artworkUrl30"] as? String)!, previewUrl: (postDict[eachTrackID]?["previewUrl"] as? String)!, collectionID: (postDict[eachTrackID]?["collectionId"] as? Int)!, collectionName: (postDict[eachTrackID]?["collectionName"] as? String)!, primaryGenreName: (postDict[eachTrackID]?["primaryGenreName"] as? String)!)
            
            
            questionArray.append(eachQuestion)
            print("\(eachQuestion.artistName) is appended")
            
        }

        let userDefault = UserDefaults.standard
        
        userDefault.set(questionArray, forKey: "questionArray")

        for index in 0..<questionArray.count {

            let eachSong = questionArray[index].previewUrl

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

                    if downloadCount == questionArray.count {

                        progressRing.setProgress(value: CGFloat(downloadCount * 20), animationDuration: 0.01) {

                            let registerVC = vC.storyboard?.instantiateViewController(withIdentifier: "PlayPage")

                            vC.present(registerVC!, animated: true, completion: nil)
                        }

                    } else {
                        progressRing.setProgress(value: CGFloat(downloadCount * 20 ), animationDuration: 0.01) {}

                    }
                }

            }
        }
    })

}
