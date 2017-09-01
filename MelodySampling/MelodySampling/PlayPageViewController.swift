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

    var ref: DatabaseReference!

    var totalTimeStart: Double = 0.0

    var coverView = UIView()

    var countDownLabel = UILabel()

    var timeCoutdown: Int = 3

    var fetchResultController: NSFetchedResultsController<QuestionMO>!

    var fetchDistractorController: NSFetchedResultsController<DistractorMO>!

    var resultMO: ResultMO!

    var distractorMO: DistractorMO!

    var distractors: [DistractorMO] = []

    var questions: [QuestionMO] = []

    var player: AVAudioPlayer?

    let path: String = NSHomeDirectory() + "/Documents/"

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

    let userDefault = UserDefaults.standard

    var trackNameArray = [String]()

    var artistNameArray = [String]()

    @IBOutlet weak var profileBackgroundContentView: UIView!

    @IBOutlet weak var userNameLabel: UILabel!

    @IBOutlet weak var trackIndicator0: UIImageView!

    @IBOutlet weak var trackIndicator1: UIImageView!

    @IBOutlet weak var trackIndicator2: UIImageView!

    @IBOutlet weak var trackIndicator3: UIImageView!

    @IBOutlet weak var trackIndicator4: UIImageView!

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

    @IBOutlet weak var tableViewHeightConstrains: NSLayoutConstraint!

    @IBOutlet weak var playingSongLabel: UILabel!

    @IBOutlet weak var leftStarsStackView: UIStackView!

    @IBOutlet weak var rightStarsStackView: UIStackView!

    @IBOutlet weak var rightUserImageView: UIImageView!

    @IBOutlet weak var leftUserImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        if let userProfileImageData = userDefault.object(forKey: "UserProfileImage") as? Data {

            rightUserImageView.image = UIImage(data: userProfileImageData)

        }

        leftStarsStackView.isHidden = true
        rightStarsStackView.isHidden = true

        self.tableView.delegate = self

        self.tableView.dataSource = self

        trackIndicator0.tag = 0
        trackIndicator1.tag = 1
        trackIndicator2.tag = 2
        trackIndicator3.tag = 3
        trackIndicator4.tag = 4

        if let userName = userDefault.object(forKey: "userName") as? String {
            userNameLabel.text = userName
        } else {
            userNameLabel.text = "Player"
        }

        let fetchRequest: NSFetchRequest<QuestionMO> = QuestionMO.fetchRequest()

        let sortDescriptor = NSSortDescriptor(key: "indexNo", ascending: true)

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

            let distractorRequest: NSFetchRequest<DistractorMO> = DistractorMO.fetchRequest()

            do {

                distractors = try context.fetch(distractorRequest)

            } catch {
                print(error)
            }

        }
        print("現在 CoreData 中有 \(questions.count) 筆資料")

        var counter = 0

        for question in questions {
            if let trackName = question.trackName, let artistName = question.artistName, let _ = questions.index(of: question) {
                trackNameArray.append(trackName)
                artistNameArray.append(artistName)

                print("===== Play Page =====")
                print("第 \(counter) 首, artistName: \(String(describing: question.artistName)), trackName: \(String(describing: question.trackName))")
                counter += 1
            }
        }

        playingSongLabel.text = "\(prepareTrack)"

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

        if shuffledList != nil && shuffledList.count != 0 {

            cell.answerLabel.text = "\(shuffledList[indexPath.section])"
        } else {
            cell.answerLabel.text = "=========="
        }
        //swiftlint:enable

        cell.selectionStyle = .none

        return cell

    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        tableView.isUserInteractionEnabled = false

        let currentTime = Date().timeIntervalSince1970

        timePassed = currentTime - timeStart

        timeStart = currentTime

        switch currentTrack {
        case trackIndicator0.tag:
            trackIndicator0.image = UIImage(named: "icon_CD_white_new")
        case trackIndicator1.tag:
            trackIndicator1.image = UIImage(named: "icon_CD_white_new")
        case trackIndicator2.tag:
            trackIndicator2.image = UIImage(named: "icon_CD_white_new")
        case trackIndicator3.tag:
            trackIndicator3.image = UIImage(named: "icon_CD_white_new")
        default:
            trackIndicator4.image = UIImage(named: "icon_CD_white_new")
        }

        let aiResult = random(4)

        if aiResult > 0 {

            guard let aiScoreStr = leftUserScoreLabel.text else { return }

            guard var aiScore = Int(aiScoreStr) else { return }

            let aiGet = 600 + random(3000)

            aiScore += aiGet

            leftUserScoreLabel.text = "\(aiScore)"

        }

        let selectedAnswer = shuffledList[indexPath.section]

        let answer = trackNameArray[currentTrack]

        print("你選了 \(selectedAnswer) 個選項")
        print("你在 \(currentTrack) 首")

        player?.pause()

        //swiftlint:disable force_cast
        if judgeAnswer(input: selectedAnswer, compare: answer) {

            let currentScoreString = rightUserScoreLabel.text

            let currentScore = Double(currentScoreString!) ?? 0.0

            let scoreYouGot = scoreAfterOneSong(time: timePassed)

            score = Double(currentScore + scoreYouGot)

            let formatPrice = String(format:"%.0f", score)

            rightUserScoreLabel.text = "\(formatPrice)"

            let currentResult = EachSongResult(index: Int16(currentTrack), result: true, usedTime: timePassed, selectedAnswer: selectedAnswer)

            self.resultList.append(currentResult)

            let selectedCell = tableView.cellForRow(at: indexPath) as! AnswerTableViewCell

            selectedCell.judgeImageView.image = UIImage(named: "right")

            selectedCell.judgeImageView.isHidden = false

            selectedCell.judgeImageView.alpha = 1

            selectedCell.answerView.layer.borderColor = UIColor.mldAppleGreen.cgColor

//            Analytics.logEvent(, parameters: <#T##[String : Any]?#>)

            UIView.animate(withDuration: 1.0, animations: {
                selectedCell.judgeImageView.alpha = 0
                selectedCell.answerView.layer.borderColor = UIColor.white.cgColor

            })

            print("答對了")
        } else {

            let currentResult = EachSongResult(index: Int16(currentTrack), result: false, usedTime: timePassed, selectedAnswer: selectedAnswer)

            let correctIndex = IndexPath(row: 0, section: shuffledList.index(of: answer)!)
            self.resultList.append(currentResult)

            var selectedCell = tableView.cellForRow(at: indexPath) as! AnswerTableViewCell

            var correctCell = tableView.cellForRow(at: correctIndex) as! AnswerTableViewCell

            selectedCell.judgeImageView.image = UIImage(named: "wrong")
            correctCell.judgeImageView.image = UIImage(named: "right")

            selectedCell.judgeImageView.alpha = 1
            correctCell.judgeImageView.alpha = 1

            selectedCell.judgeImageView.isHidden = false
            correctCell.judgeImageView.isHidden = false

            selectedCell.answerView.layer.borderColor = UIColor.mldOrangeRed.cgColor
            correctCell.answerView.layer.borderColor = UIColor.mldAppleGreen.cgColor

            UIView.animate(withDuration: 1.0, animations: {
                selectedCell.judgeImageView.alpha = 0
                selectedCell.answerView.layer.borderColor = UIColor.white.cgColor

                correctCell.judgeImageView.alpha = 0
                correctCell.answerView.layer.borderColor = UIColor.white.cgColor

            })

            print("答錯了，正解是 \(answer)")
        }
        //swiftlint:enable

        if prepareTrack == 5 {

            player?.pause()

            userDefault.set(score, forKey: "Score")

            guard let uid = userDefault.object(forKey: "uid") as? String else { return }

            self.ref = Database.database().reference()

            var prepareForUpload = [SendToFirebase]()

            let historyRef = self.ref.child("gameHistory").child(uid).childByAutoId()

            for i in 0..<resultList.count {

                let trackName = "track" + String(i)

                historyRef.child(trackName).setValue([
                    "artistID": questions[i].artistID,
                    "artistName": questions[i].artistName,
                    "trackID": questions[i].trackID,
                    "trackName": questions[i].trackName,
                    "artworkUrl": questions[i].artworkUrl,
                    "previewUrl": questions[i].previewUrl,
                    "result": resultList[i].result,
                    "collectionID": questions[i].collectionID,
                    "collectionName": questions[i].collectionName,
                    "primaryGenreName": questions[i].primaryGenreName,
                    "index": Int(resultList[i].index),
                    "usedTime": resultList[i].usedTime,
                    "selectedAnswer": resultList[i].selectedAnswer

                    ])

                if let selectedGenre = userDefault.object(forKey: "selectedGenre") as? String {

                    Analytics.logEvent( selectedGenre, parameters: [
                        "ArtistID": questions[i].artistID as? NSObject,
                        "ArtistName": questions[i].artistName as? NSObject,
                        "trackID": questions[i].trackID as? NSObject,
                        "trackName": questions[i].trackName as? NSObject,
                        "result": resultList[i].result as? NSObject,
                        "collectionID": questions[i].collectionID as? NSObject,
                        "collectionName": questions[i].collectionName as? NSObject,
                        "primaryGenreName": questions[i].primaryGenreName as? NSObject,
                        "usedTime": resultList[i].usedTime as? NSObject,
                        "selectedAnswer": resultList[i].selectedAnswer as? NSObject
                        ])

                }

                Analytics.logEvent("song\(i)", parameters: [
                    "QuestionIndex": "song\(i)" as NSObject,
                    "ArtistID": questions[i].artistID as? NSObject,
                    "ArtistName": questions[i].artistName as? NSObject,
                    "trackID": questions[i].trackID as? NSObject,
                    "trackName": questions[i].trackName as? NSObject,
                    "result": resultList[i].result as? NSObject,
                    "collectionID": questions[i].collectionID as? NSObject,
                    "collectionName": questions[i].collectionName as? NSObject,
                    "primaryGenreName": questions[i].primaryGenreName as? NSObject,
                    "usedTime": resultList[i].usedTime as? NSObject,
                    "selectedAnswer": resultList[i].selectedAnswer as? NSObject
                    ])

            }

            let now = Date().timeIntervalSince1970

            let formatedScore = String(format: "%.0f", score)
            let formatedTime = String(format: "%.0f", now)

            historyRef.child("score").setValue(formatedScore)
            historyRef.child("date").setValue(formatedTime)

            for eachResult in resultList {

                if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {

                    self.resultMO = ResultMO(context: appDelegate.persistentContainer.viewContext)

                    self.resultMO.index = eachResult.index
                    self.resultMO.result = eachResult.result
                    self.resultMO.usedTime = eachResult.usedTime
                    self.resultMO.selectedAnswer = eachResult.selectedAnswer

                    appDelegate.saveContext()

                }
            }

            print(resultList)

            let totalTimePassed = now - totalTimeStart

            // MARK: Total playing time for Google analytics
            Analytics.logEvent("TotalPlayingTime", parameters: ["PlayingTime": totalTimePassed as NSObject])

            if let selectedGenrer = userDefault.object(forKey: "selectedGenre") as? String {

                Analytics.logEvent("TotalPlayingTimeWithGenre", parameters: [selectedGenrer: totalTimePassed as NSObject])
            }

            let delayTime = DispatchTime.now() + .milliseconds(800)

            DispatchQueue.global().asyncAfter(deadline: delayTime, execute: {

                let registerVC = self.storyboard?.instantiateViewController(withIdentifier: "ResultPage")

                self.present(registerVC!, animated: true, completion: nil)

            })

        } else {

            var fakeList: [[String]] = []

            while fakeList.count != 5 {

                var eachFakeList: [String] = []

                while eachFakeList.count != 3 {

                    let firstItem = distractors.first

                    guard let distractor = firstItem?.distractorStr else { return }
                    eachFakeList.append(distractor)

                    distractors.remove(at: 0)

                }

                fakeList.append(eachFakeList)

                print(eachFakeList)
            }

            questionList = fakeList[prepareTrack]

            questionList.append(trackNameArray[prepareTrack])

            for eachDistractor in questionList {
                Analytics.logEvent("distractors", parameters: ["distractor": eachDistractor as NSObject])
            }

            shuffledList = questionList.shuffled()

            let delayTime = DispatchTime.now() + .milliseconds(1500)

            let fileName = self.path + self.songFileNameList[self.prepareTrack]

            DispatchQueue.main.asyncAfter(deadline: delayTime, execute: {

                tableView.reloadData()

                self.player?.pause()

                do {

                    self.player = try AVAudioPlayer(contentsOf: URL(string: fileName)!)

                } catch {
                    self.player = nil
                }

                tableView.isUserInteractionEnabled = true

                self.player?.play()

                self.currentTrack = self.prepareTrack

                print("現在是 \(self.currentTrack) 首")

                self.prepareTrack += 1

                self.playingSongLabel.text = "\(self.prepareTrack)"

            })

        }
    }

    func startGuessing() {

        print("現在在第 \(currentTrack) 首")
        print("接下來是第 \(prepareTrack) 首")

        self.shuffledList = []

        for index in 0..<3 {
            print(index)
            let distractorItem = distractors[index]

            guard let distractor = distractorItem.distractorStr else { return }

            if self.questionList.contains(distractor) == false {
                self.questionList.append(distractor)
            }
        }

        for eachDistractor in self.questionList {
            Analytics.logEvent("distractors", parameters: ["distractor": eachDistractor as NSObject])
        }

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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let leftUserDiameter = self.leftUserImageView.frame.width
        let rightUserDiameter = self.rightUserImageView.frame.width

        leftUserImageView.layer.cornerRadius = leftUserDiameter / 2

        rightUserImageView.layer.cornerRadius = rightUserDiameter / 2

        let tableViewHeight = Double(UIScreen.main.bounds.height) - Double(profileBackgroundContentView.frame.height) - 31 - 32

        if tableViewHeight < 310.0 {

            self.tableViewHeightConstrains.constant = CGFloat(tableViewHeight)
            self.view.layoutIfNeeded()
        }

        setCoverView(coverView, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)

        setCountDownLabelStyle(countDownLabel, screen: UIScreen.main, height: 80, width: 80)

        countDownLabel.text = "\(timeCoutdown)"

        self.view.addSubview(coverView)

        self.view.addSubview(countDownLabel)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        for i in 1..<4 {
            let delayTime = DispatchTime.now() + .seconds(i)
            DispatchQueue.main.asyncAfter(deadline: delayTime, execute: {
                self.timeCoutdown -= 1
                self.countDownLabel.text = "\(self.timeCoutdown)"

                if self.timeCoutdown == 0 {
                    self.countingTrigger()
                }
            })

        }

    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.tableView.frame.height / 4
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        let clearDistractorData = CheckQuestionInCoreData()
        clearDistractorData.clearDistractorMO()
    }

    func countingTrigger() {

            countDownLabel.isHidden = true
            coverView.isHidden = true

            self.timeStart = Date().timeIntervalSince1970

            totalTimeStart = self.timeStart

            self.startGuessing()
    }

}
