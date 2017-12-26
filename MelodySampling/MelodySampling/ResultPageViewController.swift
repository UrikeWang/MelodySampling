//
//  ResultPageViewController.swift
//  MelodySampling
//
//  Created by moon on 2017/8/11.
//  Copyright © 2017年 Marvin Lin. All rights reserved.
//

import UIKit
import CoreData
import AVFoundation

class ResultPageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {

    let userDefault = UserDefaults.standard
    
    var historyMO: HistoryMO!
    
    @IBOutlet weak var chooseCategoryLabel: UILabel!
    
    var navigationResults = [ResultToShow]()

    var trackNameArray = [String]()

    var artistNameArray = [String]()
    
    @IBOutlet weak var nextGameContentView: UIView!
    
    @IBOutlet weak var sameGenreContentView: UIView!
    
    var resultsArray = [EachSongResult]()

    let documentsURL = NSHomeDirectory() + "/Documents/"
    
    var player: AVAudioPlayer?
    
    let path: String = NSHomeDirectory() + "/Documents/"
    
    let songFileNameList = ["song0.m4a", "song1.m4a", "song2.m4a", "song3.m4a", "song4.m4a"]

    @IBOutlet weak var userImageView: UIImageView!

    @IBOutlet weak var invisibleNextGameButtonOutlet: UIButton!

    @IBAction func invisibleNextGameButtonTapped(_ sender: UIButton) {
        saveResultToHistory()
        
        // MARK: The [1] is TypeChooseViewController
        //swiftlint:disable force_cast
        let navigationViewControllers: [UIViewController] = self.navigationController?.viewControllers as! [UIViewController]
        //swiftlint:enable
        print("Pop to navigationControllers[1], and seet player to nil")
        
        self.player?.pause()
        
        self.navigationController?.popToViewController(navigationViewControllers[1], animated: true)
    }
    
    @IBOutlet weak var invisiblePlayAgainButtonOutlet: UIButton!
    
    @IBAction func invisiblePlayAgainButtonTapped(_ sender: UIButton) {
        
        saveResultToHistory()
        
        self.player?.pause()
        
        let downloadManager = DownloadManager()
        
        if let languageSelected = userDefault.object(forKey: "selectedGenre") as? String {
            
            var trackCounter: Int
            
            if let unwrapCounter = UserDefaults.standard.object(forKey: "trackCounter") as? Int {
                
                trackCounter = unwrapCounter
                
            } else {
                trackCounter = 1200
            }
            
            print("trackCounter: \(trackCounter)")
            
            let randomUserManager = RandomUserManager()
            
            randomUserManager.requestAUser()
            
            downloadManager.downloadRandomQuestion(selected: languageSelected, max: trackCounter, viewController: self)
        }
        
    }

    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var profilePageView: UIView!

    @IBOutlet weak var lowerView: UIView!

    @IBOutlet weak var userNameLabel: UILabel!

    var score: Double = 0

    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBOutlet weak var playAgainLabel: UILabel!

    @IBOutlet weak var userProfileImageView: UIImageView!

    @IBOutlet weak var userStarsStackView: UIStackView!

    @IBOutlet weak var touchHintLabel: UILabel!
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        let imageDiameter = self.userProfileImageView.frame.width

        userProfileImageView.layer.cornerRadius = imageDiameter / 2

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        sameGenreContentView.layer.cornerRadius = 30
        
        nextGameContentView.layer.cornerRadius = 30
        
        addOpacityAnimation(label: touchHintLabel)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let winOrLose = userDefault.bool(forKey: "WinOrLose")
        
        print("WinOrLose: \(winOrLose)")
        
        let selfNavigation = self.navigationController as? PlayingNavigationController
        
        if let results = selfNavigation?.resultArray {
            
            navigationResults = results
            
            print("===== below is rsult page =====")
            print(navigationResults)
            
        } else {
            // TODO: Error handling here, uiAlert and pop to rootVC
            print("Something wrong in navigation")
        }
        
        self.invisibleNextGameButtonOutlet.backgroundColor = UIColor.clear
        
        self.invisibleNextGameButtonOutlet.setTitleColor(UIColor.clear, for: .normal)
        
        self.invisiblePlayAgainButtonOutlet.setTitleColor(UIColor.clear, for: .normal)
        
        self.playAgainLabel.text = NSLocalizedString("Play again", comment: "Play again label on result page")
        
        self.chooseCategoryLabel.text = NSLocalizedString("Choose Category", comment: "Choose category label on result page")
        
        self.touchHintLabel.text = NSLocalizedString("⬇︎Tap to replay song", comment: "Touch Hint Label")
        
        if let userProfileImageData = userDefault.object(forKey: "UserProfileImage") as? Data {
            
            userProfileImageView.image = UIImage(data: userProfileImageData)
        }
        
        userStarsStackView.isHidden = true
        
        tableView.delegate = self
        
        tableView.dataSource = self
        
        userProfileImageView.layer.shadowColor = UIColor.mldBlack50.cgColor
        
        userProfileImageView.layer.shadowOffset = CGSize(width: 2, height: 2)
        
        userProfileImageView.layer.shadowRadius = 4
        
        if let userName = userDefault.object(forKey: "userName") as? String {
            userNameLabel.text = userName
        } else {
            userNameLabel.text = "Player"
        }
        
        score = (userDefault.object(forKey: "Score") as? Double)!
        
        scoreLabel.text = "\(String(format: "%.0f", score))"
        
        let imageDiameter = self.userProfileImageView.frame.width
        
        userProfileImageView.layer.cornerRadius = imageDiameter / 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // MARK: This quiz only has 5 questions
        return 5
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cellIdentifier = "ResultCell"
        
        //swiftlint:disable force_cast
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! ResultTableViewCell
        //swiftlint:enable
        
        let eachResult = navigationResults[indexPath.row]
        
        cell.trackNameLabel.text = "\(eachResult.trackName)"
        cell.artistNameLabel.text = "\(eachResult.artistName)"
        
        let usedTime = String(format:"%.1f", eachResult.usedTime)
        
        cell.usedTimeLabel.text = "\(usedTime)"
        
        if eachResult.result {
            cell.judgementImageView.image = UIImage(named: "right")
        } else {
            cell.judgementImageView.image = UIImage(named: "wrong")
        }
        
        let artworkUrl = eachResult.artworkUrl
        
        DispatchQueue.global().async {
            
            if let data = try? Data(contentsOf: URL(string: artworkUrl)!) {
                
                DispatchQueue.main.async {
                    
                    cell.artworkImageView.image = UIImage(data: data)
                    
                }
            }
        }
        
        let backGroundView = UIView()
        
        backGroundView.backgroundColor = UIColor.mldBlueBlue
        
        cell.selectedBackgroundView = backGroundView
        
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        if Double(UIScreen.main.bounds.height) > 665 {

        let screenSize = UIScreen.main.bounds

        let screenHeight = screenSize.height

        let tableHeight = screenHeight - profilePageView.frame.height - lowerView.frame.height

        return tableHeight / CGFloat(5.0)
        }

        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // TODO: Play song againg, after user selected
        let historySelected = navigationResults[indexPath.row]
        
        let fileName = self.path + self.songFileNameList[indexPath.row]
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            
            
            self.player = try AVAudioPlayer(contentsOf: URL(string: fileName)!)
            
        } catch {
            
            self.player = nil
        }
        
        self.player?.play()
        
        print("You selected \n \(historySelected.trackName) \n \(historySelected.artistName)")
        print("TrackSong: \(historySelected.previewUrl)")
    }

    func saveResultToHistory() {

        var picIndex: Int = 0
        var counter: Double = 1.0

        for question in navigationResults {

            let artistID = question.artistID
                let artistName = question.artistName
            let trackID = question.trackID
            let trackName = question.trackName
            let artworkUrl = question.artworkUrl
            let previewUrl = question.previewUrl
            let collectionID = question.collectionID
            let collectionName = question.collectionName
            let primaryGenreName = question.primaryGenreName

                if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {

                    self.historyMO = HistoryMO(context: appDelegate.persistentContainer.viewContext)

                    self.historyMO.artworkImage = UIImagePNGRepresentation(UIImage(named: "icon_CD_white_new")!)! as NSData

                    picIndex += 1

                    self.historyMO.timeIndex = Double(Date().timeIntervalSince1970) + counter

                    counter += 1.0

                    self.historyMO.artistID = String(artistID)
                    self.historyMO.artistName = artistName
                    self.historyMO.trackID = String(trackID)
                    self.historyMO.trackName = trackName
                    self.historyMO.artworkUrl = artworkUrl
                    self.historyMO.previewUrl = previewUrl
                    self.historyMO.collectionID = String(collectionID)
                    self.historyMO.collectionName = collectionName
                    self.historyMO.primaryGenreName = primaryGenreName

                    appDelegate.saveContext()
                
            }

        }
        
        // MARK: Leave these code here, delete this aft 1.1.10 or later
        let checkQuestion = CheckQuestionInCoreData()
        
        checkQuestion.clearQuestionMO()
        
        checkQuestion.clearResultMO()

    }
}
