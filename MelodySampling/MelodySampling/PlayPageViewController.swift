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
import CoreData
import Alamofire

class PlayPageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {

    var fetchResultController: NSFetchedResultsController<QuestionMO>!

    var resultMO: ResultMO!

    var questions: [QuestionMO] = []

    var player: AVAudioPlayer?

    let path: String = NSHomeDirectory() + "/Documents/"

    var fakeArtistList = ["Fake 1", "Fake 2", "Fake 3"]

    var questionList = [String]()

    var currentTrack: Int = 0

    var prepareTrack: Int = 1

    let songFileNameList = ["song0.m4a", "song1.m4a", "song2.m4a", "song3.m4a", "song4.m4a"]

    var shuffledList = [String]()

    var artistList = [String]()

    var resultList = [EachSongResult]()

    var timeStart: Double = 0

    var timeEnd: Double = 0

    var timePassed: Double = 0

    var score: Double = 0

    var trackNameArray = [String]()

    var artistNameArray = [String]()

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

    @IBOutlet weak var playingSongLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.delegate = self

        self.tableView.dataSource = self

        let fetchRequest: NSFetchRequest<QuestionMO> = QuestionMO.fetchRequest()

        let sortDescriptor = NSSortDescriptor(key: "artistID", ascending: true)

        fetchRequest.sortDescriptors = [sortDescriptor]

        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {

            let context = appDelegate.persistentContainer.viewContext

            fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)

            fetchResultController.delegate = self

            do {

                try fetchResultController.performFetch()

                if let fetchedObjects = fetchResultController.fetchedObjects {

                    questions = fetchedObjects

                }

            } catch {
                print(error)
            }
        }
        print("現在 CoreData 中有 \(questions.count) 筆資料")

        for question in questions {
            if let trackName = question.trackName, let artistName = question.artistName, let artworkUrl = question.artworkUrl, let index = questions.index(of: question) {
                trackNameArray.append(trackName)
                artistNameArray.append(artistName)

                let destinnation: DownloadRequest.DownloadFileDestination = { _, _ in

                    let documentsURL = NSHomeDirectory() + "/Documents/"
                    let fileURL = URL(fileURLWithPath: documentsURL.appending("artworkImage\(index).jpg"))

                    return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
                }

                Alamofire.download(artworkUrl, to: destinnation).response { _ in
                }

                print(trackName, artistName)
            }
        }

        playingSongLabel.text = "\(prepareTrack)"

        self.timeStart = Date().timeIntervalSince1970

        self.startGuessing()

    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return trackNameArray.count
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

        let answer = trackNameArray[currentTrack]

        print("你選了 \(selectedAnswer) 個選項")
        print("你在 \(currentTrack) 首")

        let currentTime = Date().timeIntervalSince1970

        timePassed = currentTime - timeStart

        timeStart = currentTime

        if judgeAnswer(input: selectedAnswer, compare: answer) {

            let currentScoreString = rightUserScoreLabel.text

            let currentScore = Double(currentScoreString!) ?? 0.0

            let scoreYouGot = scoreAfterOneSong(time: timePassed)

            score = Double(currentScore + scoreYouGot)

            let formatPrice = String(format:"%.0f", score)

            rightUserScoreLabel.text = "\(formatPrice)"

            let currentResult = EachSongResult(index: Int16(currentTrack), result: true, usedTime: timePassed)

            self.resultList.append(currentResult)

            print("答對了")
        } else {

            let currentResult = EachSongResult(index: Int16(currentTrack), result: false, usedTime: timePassed)

            self.resultList.append(currentResult)

            print("答錯了，正解是 \(answer)")
        }

        if prepareTrack == 5 {

            player?.pause()

            player = nil

            let userDefault = UserDefaults.standard

            userDefault.set(score, forKey: "Score")

            for eachResult in resultList {

                if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {

                    self.resultMO = ResultMO(context: appDelegate.persistentContainer.viewContext)

                    self.resultMO.index = eachResult.index
                    self.resultMO.result = eachResult.result
                    self.resultMO.usedTime = eachResult.usedTime

                    appDelegate.saveContext()

                }
            }

            print(resultList)

            let registerVC = self.storyboard?.instantiateViewController(withIdentifier: "ResultPage")

            self.present(registerVC!, animated: true, completion: nil)

        } else {

            questionList = fakeArtistList

            questionList.append(trackNameArray[prepareTrack])

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

                playingSongLabel.text = "\(prepareTrack)"

            }
        }
    }

    func startGuessing() {
        //進行第0首歌的猜謎

        print("現在在第 \(currentTrack) 首")
        print("接下來是第 \(prepareTrack) 首")
        self.questionList = self.fakeArtistList

        self.questionList.append(self.trackNameArray[self.currentTrack])

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
