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

var ref: DatabaseReference!

func downloadQuestion(genre code: Int) {

    let genreCode = "genreCode\(code)"

    print("目標題庫是 \(genreCode)")

    ref = Database.database().reference()

    ref.child("questionBanks").child("mandarin").child("\(genreCode)").child("question1").queryOrderedByKey().observeSingleEvent(of: .value, with: { (snapshot) in

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
