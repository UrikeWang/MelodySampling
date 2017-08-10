//
//  PlayPageViewController.swift
//  MelodySampling
//
//  Created by moon on 2017/8/10.
//  Copyright © 2017年 Marvin Lin. All rights reserved.
//

import UIKit
import AVFoundation
import Firebase

class PlayPageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var ref: DatabaseReference!

    var player: AVAudioPlayer?

    let path: String = NSHomeDirectory() + "/Documents/"

    var fakeArtistList = ["Fake 1", "Fake 2", "Fake 3"]

    var questionList = [String]()

    var currentTrack: Int = 0

    var prepareTrack: Int = 1

    let songFileNameList = ["song0.m4a", "song1.m4a", "song2.m4a", "song3.m4a", "song4.m4a"]

    var shuffledList = [String]()

    var artistList = [String]()

    var resultList = [Bool]()

    var timeStart: Double?

    var timeEnd: Double?

    var timePassed: Double?

    var score: Double = 0

    @IBOutlet weak var rightUserScoreLabel: UILabel! {
        didSet {
            rightUserScoreLabel.text = "0000"
        }
    }

    @IBOutlet weak var leftUserScoreLabel: UILabel! {
        didSet {
            leftUserScoreLabel.text = "0000"
        }
    }
    
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.delegate = self

        self.tableView.dataSource = self

        self.ref = Database.database().reference()

        ref.child("questionBanks").child("mandarin").child("genreCod1").child("question1").queryOrderedByKey().observeSingleEvent(of: .value, with: { (snapshot) in

            let postDict = snapshot.value as? [String: AnyObject] ?? [:]

            for eachTrackID in postDict {

                let temp = eachTrackID.value as? [String: AnyObject]
                //                print(temp)

                guard let artist = temp?["artistName"] else { return }

                self.artistList.append((artist as? String)!)

            }

            print("Artlist downloading done")

            self.timeStart = Date().timeIntervalSince1970

            self.startGuessing()

        })

    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return shuffledList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "AnswerCell"

        //swiftlint:disable force_cast
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! AnswerTableViewCell

        cell.answerLabel.text = shuffledList[indexPath.section]
        //swiftlint:enable
        cell.backgroundColor = UIColor.clear

        cell.selectionStyle = .none
        
        return cell

    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedAnswer = shuffledList[indexPath.section]

        let answer = artistList[currentTrack]

        print("你選了 \(selectedAnswer) 個選項")
        print("你在 \(currentTrack) 首")

        if judgeAnswer(input: selectedAnswer, compare: answer) {

            let currentTime = Date().timeIntervalSince1970

            timePassed = currentTime - timeStart!

            timeStart = currentTime

            let currentScoreString = rightUserScoreLabel.text

            let currentScore = Double(currentScoreString!) ?? 0.0

            let scoreYouGot = scoreAfterOneSong(time: timePassed!)

            score = Double(currentScore + scoreYouGot)

            let formatPrice = String(format:"%.0f", score)

            rightUserScoreLabel.text = "\(formatPrice)"

            resultList.append(true)
            print("答對了")
        } else {

            resultList.append(false)
            print("答錯了，正解是 \(answer)")
        }

        if prepareTrack == 5 {

            player?.pause()

            player = nil

            performSegue(withIdentifier: "goToResultPage", sender: self)

        } else {

            questionList = fakeArtistList

            questionList.append(artistList[prepareTrack])

            shuffledList = questionList.shuffled()

            tableView.reloadData()

            player?.pause()

            let fileName = self.path + songFileNameList[prepareTrack]

            do {

                player = try AVAudioPlayer(contentsOf: URL(string: fileName)!)

            } catch {
                player = nil
            }

            player?.play()

            currentTrack = prepareTrack
            
            print("現在是 \(currentTrack) 首")

            if currentTrack == 5 {
                
                performSegue(withIdentifier: "goToResultPage", sender: self)
                
                player?.pause()
                
                player = nil

            } else {
            
                prepareTrack += 1

            }
        }
    }

    func startGuessing() {
        //進行第0首歌的猜謎

        print("現在在第 \(currentTrack) 首")
        print("接下來是第 \(prepareTrack) 首")
        self.questionList = self.fakeArtistList

        self.questionList.append(self.artistList[self.currentTrack])

        self.shuffledList = self.questionList.shuffled()

        self.tableView.reloadData()

        let fileName = self.path + self.songFileNameList[self.currentTrack]

        do {

            self.player = try AVAudioPlayer(contentsOf: URL(string: fileName)!)

        } catch {
            self.player = nil
        }

        self.player?.play()
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 79
    }

}
