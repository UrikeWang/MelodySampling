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

//swiftlint:disable type_body_length
class PlayPageViewController: UIViewController, NSFetchedResultsControllerDelegate {

    var ref: DatabaseReference!

    var totalTimeStart: Double = 0.0
    var coverView = UIView()
    var countDownLabel = UILabel()
    var timeCountdown: Int = 3
    var distractors = [String]()
    var fakeList = [[String]]()
    var player: Player? = Player()
    let path: String = NSHomeDirectory() + "/Documents/"
    var questionList = [String]()
    var currentTrack: Int = 0
    var prepareTrack: Int = 1
    // MARK: What if one day, the source is not m4a file?
    let songFileNameList = ["song0.m4a", "song1.m4a", "song2.m4a", "song3.m4a", "song4.m4a"]
    var shuffledList = [String]()
    var artistList = [String]()
    var sendToNavigation = [ResultToShow]()
    var resultList = [EachSongResult]()
    var navigationQuestionArray = [EachQuestion]()
    weak var timer = Timer()
    var trackTimeCountdown: Int = 30
    var timeStart: Double = 0
    var timeEnd: Double = 0
    var timePassed: Double = 0
    
    var userScore: Int = 0 {
        didSet {
            if userScore != 0 {
                rightUserScoreLabel.text = "\(userScore)"
            } else {
                rightUserScoreLabel.text = "0000"
            }
        }
    }
    var userTargetScore: Int = 0
    
    var aiTotalScore: Int = 0 {
        didSet {
            leftUserScoreLabel.text = "\(aiTotalScore)"
        }
    }
    
    var aiTargetScore: Int = 0
    let userDefault = UserDefaults.standard
    var trackNameArray = [String]()
    var artistNameArray = [String]()

    @IBOutlet weak var profileBackgroundContentView: UIView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var randomUserNameLabel: UILabel!
    @IBOutlet weak var trackIndicator0: UIImageView!
    @IBOutlet weak var trackIndicator1: UIImageView!
    @IBOutlet weak var trackIndicator2: UIImageView!
    @IBOutlet weak var trackIndicator3: UIImageView!
    @IBOutlet weak var trackIndicator4: UIImageView!
    @IBOutlet weak var rightUserScoreLabel: UILabel!
    @IBOutlet weak var leftUserScoreLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var trackTimeCountdownLabel: UILabel!
    @IBOutlet weak var leftStarsStackView: UIStackView!
    @IBOutlet weak var rightStarsStackView: UIStackView!
    @IBOutlet weak var rightUserImageView: UIImageView!
    @IBOutlet weak var leftUserImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let selfNavigation = self.navigationController as? PlayingNavigationController
        
        if let questions = selfNavigation?.questionArray,
            let selfDistractors = selfNavigation?.distractorArray {
            
            print("===== This is test Navigation stored property =====")
            
            navigationQuestionArray = questions
            
            distractors = selfDistractors
            
            let fakeList0 = [
                distractors[0],
                distractors[1],
                distractors[2]
            ]
            
            let fakeList1 = [
                distractors[3],
                distractors[4],
                distractors[5]
            ]
            
            let fakeList2 = [
                distractors[6],
                distractors[7],
                distractors[8]
            ]
            
            let fakeList3 = [
                distractors[9],
                distractors[10],
                distractors[11]
            ]
            
            let fakeList4 = [
                distractors[12],
                distractors[13],
                distractors[14]
            ]
            
            fakeList = [
                fakeList0,
                fakeList1,
                fakeList2,
                fakeList3,
                fakeList4
            ]
            
            print(navigationQuestionArray)
        } else {
            // TODO: Error handling here, if something wrong, present a UIAlertwindow with "OK" button, after user touch the button, self.navigationController.popToRootViewController activate.
            print("Something wrong in navigation stored property")
        }

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
        
        var counter = 0

        for question in navigationQuestionArray {
            let trackName = question.trackName
            let artistName = question.artistName

                trackNameArray.append(trackName)
                artistNameArray.append(artistName)

                print("===== Play Page =====")
                print("第 \(counter) 首, artistName: \(String(describing: question.artistName)), trackName: \(String(describing: question.trackName))")
                counter += 1

        }

        trackTimeCountdownLabel.text = "\(trackTimeCountdown)"
        rightUserScoreLabel.text = "0000"
        leftUserScoreLabel.text = "0000"
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let randomUserImageData = userDefault.data(forKey: "RandomUserImageData"), let randomUserName = userDefault.object(forKey: "RandomUserName") as? String {
            leftUserImageView.image = UIImage(data: randomUserImageData)
            
            // username 的名字太長了,加入跑馬燈效果
            let randomUserMarqueeView = MarqueeView(frame: randomUserNameLabel.frame, title: randomUserName)
            profileBackgroundContentView.addSubview(randomUserMarqueeView)
            randomUserNameLabel.isHidden = true

        }
        
        let userMarqueeView: MarqueeView!
        
        if let userName = userDefault.object(forKey: "userName") as? String {
            userMarqueeView = MarqueeView(frame: userNameLabel.frame, title: userName)
        } else {
            userMarqueeView = MarqueeView(frame: userNameLabel.frame, title: "Player")
        }
        profileBackgroundContentView.addSubview(userMarqueeView)
        userNameLabel.isHidden = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        let leftUserDiameter = self.leftUserImageView.frame.width
        let rightUserDiameter = self.rightUserImageView.frame.width

        leftUserImageView.layer.cornerRadius = leftUserDiameter / 2
        rightUserImageView.layer.cornerRadius = rightUserDiameter / 2

        let tableViewHeight = Double(UIScreen.main.bounds.height) - Double(profileBackgroundContentView.frame.height) - 31 - 32

        setCoverView(coverView, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)

        setCountDownLabelStyle(countDownLabel, screen: UIScreen.main, height: 80, width: 80)

        countDownLabel.text = "\(timeCountdown)"

        self.view.addSubview(coverView)

        self.view.addSubview(countDownLabel)

    }


    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        for i in 1..<4 {
            let delayTime = DispatchTime.now() + .seconds(i)
            DispatchQueue.main.asyncAfter(deadline: delayTime, execute: {
                self.timeCountdown -= 1
                self.countDownLabel.text = "\(self.timeCountdown)"

                if self.timeCountdown == 0 {
                    self.countingTrigger()
                }
            })
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        let clearDistractorData = CheckQuestionInCoreData()
        clearDistractorData.clearDistractorMO()

        let selfNavigation = self.navigationController as? PlayingNavigationController
        selfNavigation?.randomUser = nil
    }
    
    @IBAction func exitButtonTapped(_ sender: UIButton) {
        
        let exitAlert = UIAlertController(title: NSLocalizedString("Exit", comment: "Exit alert title at playing page"), message: NSLocalizedString("Do you really want to exit this round?", comment:"Exit alert message at playing page"), preferredStyle: .alert)
        
        let resumeAction = UIAlertAction(title: NSLocalizedString(NSLocalizedString("Resume", comment: "Resume action in alert controller of playing page"), comment: "Resume"), style: .default) { (_) in
            
            exitAlert.dismiss(animated: true, completion: nil)
        }
        
        let exitAction = UIAlertAction(title: NSLocalizedString(NSLocalizedString("Exit", comment: "Exit action in alert controller of playing page"), comment: "Exit"), style: .default) { (_) in
            
            self.player?.stopAVPlayer()
            self.timer?.invalidate()
            let selfNavigation = self.navigationController as? PlayingNavigationController
            selfNavigation?.popToRootViewController(animated: true)
        }
        
        exitAlert.addAction(exitAction)
        exitAlert.addAction(resumeAction)
        
        self.present(exitAlert, animated: true, completion: nil)
        
    }
    @objc func updateRandomUserScore(_ sender: Timer) {
        if aiTotalScore != aiTargetScore {
            aiTotalScore += 1
        } else {
            sender.invalidate()
        }
    }
    
    @objc func updateUserScore(_ sender: Timer) {
        if userScore != userTargetScore {
            userScore += 1
        } else {
            sender.invalidate()
        }
    }
}

// MARK: - TableViewDelegate, TableViewDataSource
extension PlayPageViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.tableView.frame.height / 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "AnswerCell"
        
        //swiftlint:disable force_cast
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! AnswerTableViewCell
        
        if shuffledList.count == 4 {
            
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
        
        timer?.invalidate()
        
        self.trackTimeCountdown = 30
        
        trackTimeCountdownLabel.text = "\(self.trackTimeCountdown)"
        
        let currentTime = Date().timeIntervalSince1970
        
        timePassed = currentTime - timeStart
        
        timeStart = currentTime
        
        updateTrackPic(input: currentTrack)
        
        let aiResult = random(3)
        
        if aiResult > 0 {
            // MARK: - AI Score animate
            guard let aiScoreStr = leftUserScoreLabel.text else { return }
            
            let aiGet = 600 + random(2000)
            
            aiTargetScore = aiTotalScore + aiGet
            
            _ = Timer.scheduledTimer(timeInterval: 0.000001, target: self, selector: #selector(updateRandomUserScore(_:)), userInfo: nil, repeats: true)
            
        }
        
        let selectedAnswer = shuffledList[indexPath.section]
        
        let answer = trackNameArray[currentTrack]
        
        print("你選了 \(selectedAnswer) 個選項")
        print("你在 \(currentTrack) 首")
        
        self.player?.stopAVPlayer()
        
        //swiftlint:disable force_cast
        if judgeAnswer(input: selectedAnswer, compare: answer) {
            
            let scoreYouGot = Int(scoreAfterOneSong(time: timePassed))
            
            userTargetScore = userScore + scoreYouGot
            
            _ = Timer.scheduledTimer(timeInterval: 0.000001, target: self, selector: #selector(updateUserScore(_:)), userInfo: nil, repeats: true)
            
            let currentResult = EachSongResult(index: Int16(currentTrack), result: true, usedTime: timePassed, selectedAnswer: selectedAnswer)
            
            self.resultList.append(currentResult)
            
            let selectedCell = tableView.cellForRow(at: indexPath) as! AnswerTableViewCell
            
            selectedCell.judgeImageView.image = UIImage(named: "right")
            selectedCell.judgeImageView.isHidden = false
            selectedCell.judgeImageView.alpha = 1
            selectedCell.answerView.backgroundColor = .sqCelery
            
            UIView.animate(withDuration: 0.8, animations: {
                selectedCell.judgeImageView.alpha = 0
                selectedCell.answerView.layer.borderColor = UIColor.white.cgColor
                selectedCell.answerView.backgroundColor = .white
                
            })
            
            print("答對了")
        } else {
            
            let currentResult = EachSongResult(index: Int16(currentTrack), result: false, usedTime: timePassed, selectedAnswer: selectedAnswer)
            
            let correctIndex = IndexPath(row: 0, section: shuffledList.index(of: answer)!)
            self.resultList.append(currentResult)
            
            let selectedCell = tableView.cellForRow(at: indexPath) as! AnswerTableViewCell
            
            let correctCell = tableView.cellForRow(at: correctIndex) as! AnswerTableViewCell
            
            selectedCell.judgeImageView.image = UIImage(named: "wrong")
            correctCell.judgeImageView.image = UIImage(named: "right")
            
            selectedCell.judgeImageView.alpha = 1
            correctCell.judgeImageView.alpha = 1
            
            selectedCell.judgeImageView.isHidden = false
            correctCell.judgeImageView.isHidden = false
            
            selectedCell.answerView.layer.borderColor = UIColor.mldOrangeRed.cgColor
            correctCell.answerView.layer.borderColor = UIColor.mldAppleGreen.cgColor
            
            correctCell.answerView.backgroundColor = .sqCelery
            selectedCell.answerView.backgroundColor = .sqPaleSalmon
            
            UIView.animate(withDuration: 1.0, animations: {
                selectedCell.judgeImageView.alpha = 0
                selectedCell.answerView.layer.borderColor = UIColor.white.cgColor
                
                correctCell.judgeImageView.alpha = 0
                correctCell.answerView.layer.borderColor = UIColor.white.cgColor
                
                correctCell.answerView.backgroundColor = .white
                selectedCell.answerView.backgroundColor = .white
                
            })
            
            
            
            print("答錯了，正解是 \(answer)")
        }
        //swiftlint:enable
        
        // MARK: - If finished one round, execute here.
        if prepareTrack == 5 {
            
            self.player?.stopAVPlayer()
            
            if userTargetScore > aiTargetScore {
                userDefault.set(true, forKey: "WinOrLose")
            } else {
                userDefault.set(false, forKey: "WinOrLose")
            }
            
            userDefault.set(userTargetScore, forKey: "Score")
            
            guard let uid = userDefault.object(forKey: "uid") as? String else { return }
            
            self.ref = Database.database().reference()
            
            var prepareForUpload = [SendToFirebase]()
            
            let historyRef = self.ref.child("gameHistory").child(uid).childByAutoId()
            
            for i in 0..<resultList.count {
                
                let trackName = "track" + String(i)
                
                historyRef.child(trackName).setValue([
                    "artistID": navigationQuestionArray[i].artistID,
                    "artistName": navigationQuestionArray[i].artistName,
                    "trackID": navigationQuestionArray[i].trackID,
                    "trackName": navigationQuestionArray[i].trackName,
                    "artworkUrl": navigationQuestionArray[i].artworkUrl,
                    "previewUrl": navigationQuestionArray[i].previewUrl,
                    "result": resultList[i].result,
                    "collectionID": navigationQuestionArray[i].collectionID,
                    "collectionName": navigationQuestionArray[i].collectionName,
                    "primaryGenreName": navigationQuestionArray[i].primaryGenreName,
                    "index": Int(resultList[i].index),
                    "usedTime": resultList[i].usedTime,
                    "selectedAnswer": resultList[i].selectedAnswer
                    
                    ])
                
                if let selectedGenre = userDefault.object(forKey: "selectedGenre") as? String {
                    
                    Analytics.logEvent( selectedGenre, parameters: [
                        "ArtistID": navigationQuestionArray[i].artistID as? NSObject,
                        "ArtistName": navigationQuestionArray[i].artistName as? NSObject,
                        "trackID": navigationQuestionArray[i].trackID as? NSObject,
                        "trackName": navigationQuestionArray[i].trackName as? NSObject,
                        "result": resultList[i].result as? NSObject,
                        "collectionID": navigationQuestionArray[i].collectionID as? NSObject,
                        "collectionName": navigationQuestionArray[i].collectionName as? NSObject,
                        "primaryGenreName": navigationQuestionArray[i].primaryGenreName as? NSObject,
                        "usedTime": resultList[i].usedTime as? NSObject,
                        "selectedAnswer": resultList[i].selectedAnswer as? NSObject
                        ])
                    
                }
                
                Analytics.logEvent("AIResults", parameters: ["AIScore": aiTotalScore])
                
                Analytics.logEvent("song\(i)", parameters: [
                    "QuestionIndex": "song\(i)" as NSObject,
                    "ArtistID": navigationQuestionArray[i].artistID as? NSObject,
                    "ArtistName": navigationQuestionArray[i].artistName as? NSObject,
                    "trackID": navigationQuestionArray[i].trackID as? NSObject,
                    "trackName": navigationQuestionArray[i].trackName as? NSObject,
                    "result": resultList[i].result as? NSObject,
                    "collectionID": navigationQuestionArray[i].collectionID as? NSObject,
                    "collectionName": navigationQuestionArray[i].collectionName as? NSObject,
                    "primaryGenreName": navigationQuestionArray[i].primaryGenreName as? NSObject,
                    "usedTime": resultList[i].usedTime as? NSObject,
                    "selectedAnswer": resultList[i].selectedAnswer as? NSObject
                    ])
            }
            
            let selfNavigation = self.navigationController as? PlayingNavigationController
            
            selfNavigation?.resultArray = [ResultToShow]()
            
            for index in 0..<resultList.count {
                let resultToShow = ResultToShow(
                    artistID: navigationQuestionArray[index].artistID,
                    artistName: navigationQuestionArray[index].artistName,
                    trackID: navigationQuestionArray[index].trackID,
                    trackName: navigationQuestionArray[index].trackName,
                    artworkUrl: navigationQuestionArray[index].artworkUrl,
                    previewUrl: navigationQuestionArray[index].previewUrl,
                    collectionID: navigationQuestionArray[index].collectionID,
                    collectionName: navigationQuestionArray[index].collectionName,
                    primaryGenreName: navigationQuestionArray[index].primaryGenreName,
                    result: resultList[index].result,
                    usedTime: resultList[index].usedTime
                )
                
                sendToNavigation.append(resultToShow)
            }
            
            selfNavigation?.resultArray = sendToNavigation
            
            print("===== Below is NavigationResult =====")
            print(selfNavigation?.resultArray)
            
            
            let now = Date().timeIntervalSince1970
            
            let formatedScore = String(format: "%.0f", userScore)
            let formatedTime = String(format: "%.0f", now)
            
            historyRef.child("score").setValue(formatedScore)
            historyRef.child("date").setValue(formatedTime)
            
            print(resultList)
            
            let totalTimePassed = now - totalTimeStart
            
            // MARK: Total playing time for Google analytics
            
            if let selectedGenrer = userDefault.object(forKey: "selectedGenre") as? String {
                
                Analytics.logEvent("TotalPlayingTimeWithGenre", parameters: [selectedGenrer: totalTimePassed as NSObject])
                
                Analytics.logEvent("TotalPlayingTime",
                                   parameters: [
                                    "PlayingTime": totalTimePassed as NSObject,
                                    "SelectedGenre": selectedGenrer as NSObject
                    ])
            }
            
            let delayTime = DispatchTime.now() + .milliseconds(1500)
            
            DispatchQueue.main.asyncAfter(deadline: delayTime, execute: {
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                
                let resultViewController = storyboard.instantiateViewController(withIdentifier: "ResultPage")
                self.navigationController?.pushViewController(resultViewController, animated: true)
                
            })
            
        } else {
            
            // MARK: If not finished one round, go here
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
                
                self.player?.stopAVPlayer()
                
                tableView.isUserInteractionEnabled = true
                
                let songUrl = URL(fileURLWithPath: fileName)
                
                self.player?.play(songUrl: songUrl)
                
                self.currentTrack = self.prepareTrack
                
                print("現在是 \(self.currentTrack) 首")
                
                self.prepareTrack += 1
                
                let delayTime = DispatchTime.now() + .milliseconds(800)
                
                DispatchQueue.main.asyncAfter(deadline: delayTime, execute: { [weak self] in
                    
                    self?.runTime()
                    
                })
            })
        }
    }
}
//swiftlint:enable
