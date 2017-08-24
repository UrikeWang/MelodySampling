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

    var coverView = UIView()

    var countDownLabel = UILabel()

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
        }
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

        coverView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)

        coverView.backgroundColor = UIColor.mldBlack50

        countDownLabel.frame = CGRect(x: UIScreen.main.bounds.width / 2 - 40, y: UIScreen.main.bounds.height / 2 - 40, width: 80, height: 80)

        countDownLabel.layer.cornerRadius = 40

        countDownLabel.clipsToBounds = true

        countDownLabel.backgroundColor = UIColor.white

        countDownLabel.text = "3"

        countDownLabel.textColor = UIColor.black

        countDownLabel.textAlignment = .center

        countDownLabel.font = UIFont.mldTextStyleCountDownFont()

        self.view.addSubview(coverView)

        self.view.addSubview(countDownLabel)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        self.timeStart = Date().timeIntervalSince1970

        self.startGuessing()

    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.tableView.frame.height / 4
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        let clearDistractorData = CheckQuestionInCoreData()
        clearDistractorData.clearDistractorMO()
    }

}
