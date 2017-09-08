//
//  ResultPageViewController.swift
//  MelodySampling
//
//  Created by moon on 2017/8/11.
//  Copyright © 2017年 Marvin Lin. All rights reserved.
//

import UIKit
import CoreData

class ResultPageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {

    var fetchQuestionController: NSFetchedResultsController<QuestionMO>!

    var fetchResultsController: NSFetchedResultsController<ResultMO>!

    var historyMO: HistoryMO!

    var questions: [QuestionMO] = []

    var resultMO: ResultMO!

    var results: [ResultMO] = []

    var trackNameArray = [String]()

    var artistNameArray = [String]()

    var resultsArray = [EachSongResult]()

    let documentsURL = NSHomeDirectory() + "/Documents/"

    @IBOutlet weak var userImageView: UIImageView!

    @IBOutlet weak var invisibleNextGameButtonOutlet: UIButton!

    @IBAction func invisibleNextGameButtonTapped(_ sender: UIButton) {
        saveResultToHistory()
        gotoTypeChoosePage(from: self)
    }

    @IBOutlet weak var invisibleGoHomeButtonOutlet: UIButton!

    @IBAction func invisibleGoHomeButtonTapped(_ sender: UIButton) {
        saveResultToHistory()
        gotoProfilePage(from: self)
    }

    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var profilePageView: UIView!

    @IBOutlet weak var lowerView: UIView!

    @IBOutlet weak var nextBattleLabel: UILabel!

    @IBOutlet weak var nextBattleTextLabel: UILabel!

    let userDefault = UserDefaults.standard

    @IBOutlet weak var userNameLabel: UILabel!

    var score: Double = 0

    @IBOutlet weak var scoreLabel: UILabel!

    @IBOutlet weak var userProfileImageView: UIImageView!

    @IBOutlet weak var userStarsStackView: UIStackView!

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        let imageDiameter = self.userProfileImageView.frame.width

        userProfileImageView.layer.cornerRadius = imageDiameter / 2

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        nextBattleLabel.isHidden = true

        nextBattleLabel.isHidden = true
        invisibleNextGameButtonOutlet.setTitleColor(UIColor.mldLightRoyalBlue, for: .normal)

        invisibleNextGameButtonOutlet.backgroundColor = UIColor.mldTiffanyBlue

        invisibleNextGameButtonOutlet.setTitle(NSLocalizedString("Play Again", comment: "Play again text at result page."), for: .normal)

        invisibleNextGameButtonOutlet.layer.cornerRadius = 25

        invisibleNextGameButtonOutlet.clipsToBounds = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()

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
            userNameLabel.text = "This is you"
        }

        score = (userDefault.object(forKey: "Score") as? Double)!

        scoreLabel.text = "\(String(format: "%.0f", score))"

        let fetchQuestionRequest: NSFetchRequest<QuestionMO> = QuestionMO.fetchRequest()

        let fetchResultsRequest: NSFetchRequest<ResultMO> = ResultMO.fetchRequest()

        let sortDescriptor = NSSortDescriptor(key: "trackID", ascending: true)

        let resultSortDescriptor = NSSortDescriptor(key: "index", ascending: true)

        fetchQuestionRequest.sortDescriptors = [sortDescriptor]

        fetchResultsRequest.sortDescriptors = [resultSortDescriptor]

        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {

            let context = appDelegate.persistentContainer.viewContext

            fetchQuestionController = NSFetchedResultsController(fetchRequest: fetchQuestionRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)

            fetchResultsController = NSFetchedResultsController(fetchRequest: fetchResultsRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)

            fetchQuestionController.delegate = self
            fetchResultsController.delegate = self

            do {

                try fetchQuestionController.performFetch()

                if let fetchedObjects = fetchQuestionController.fetchedObjects {

                    questions = fetchedObjects
                }
            } catch {

                print(error)
            }

            do {

                try fetchResultsController.performFetch()

                if let fetchedObjects = fetchResultsController.fetchedObjects {

                    results = fetchedObjects
                }
            } catch {

                print(error)
            }
        }

        for question in questions {

            if let artistName = question.artistName, let trackName = question.trackName {

                trackNameArray.append(trackName)
                artistNameArray.append(artistName)

            }
        }

        for result in results {

            guard let selectedAnswer = result.selectedAnswer else { let selectedAnswer = "Didn't cath selectedAnswer"; continue }

            let temp = EachSongResult(index: result.index, result: result.result, usedTime: result.usedTime, selectedAnswer: selectedAnswer)
            resultsArray.append(temp)

        }
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {

    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questions.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cellIdentifier = "ResultCell"

        //swiftlint:disable force_cast
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! ResultTableViewCell
        //swiftlint:enable

        cell.trackNameLabel.text = "\(trackNameArray[indexPath.row])"
        cell.artistNameLabel.text = "\(artistNameArray[indexPath.row])"

        let usedTime = String(format:"%.1f", resultsArray[indexPath.row].usedTime)

        cell.usedTimeLabel.text = "\(usedTime)"

        if resultsArray[indexPath.row].result {
            cell.judgementImageView.image = UIImage(named: "right")
        } else {
            cell.judgementImageView.image = UIImage(named: "wrong")
        }

        let artworkUrl = questions[indexPath.row].artworkUrl

        DispatchQueue.global().async {

            if let data = try? Data(contentsOf: URL(string: artworkUrl!)!) {

                DispatchQueue.main.async {

                    cell.artworkImageView.image = UIImage(data: data)

                }
            }
        }

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        if Double(UIScreen.main.bounds.height) > 665 {

        let screenSize = UIScreen.main.bounds

        let screenHeight = screenSize.height

        let tableHeight = screenHeight - profilePageView.frame.height - lowerView.frame.height

        return tableHeight / CGFloat(questions.count)
        }

        return 80
    }

    func saveResultToHistory() {

        var picIndex: Int = 0
        var counter: Double = 1.0

        for question in self.questions {

            if let artistID = question.artistID, let artistName = question.artistName, let trackID = question.trackID, let trackName = question.trackName, let artworkUrl = question.artworkUrl, let previewUrl = question.previewUrl, let collectionID = question.collectionID, let collectionName = question.collectionName, let primaryGenreName = question.primaryGenreName {

                if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {

                    self.historyMO = HistoryMO(context: appDelegate.persistentContainer.viewContext)

                    self.historyMO.artworkImage = UIImagePNGRepresentation(UIImage(named: "collectionPlaceHolder")!)! as NSData

                    picIndex += 1

                    self.historyMO.timeIndex = Double(Date().timeIntervalSince1970) + counter

                    counter += 1.0

                    self.historyMO.artistID = artistID
                    self.historyMO.artistName = artistName
                    self.historyMO.trackID = trackID
                    self.historyMO.trackName = trackName
                    self.historyMO.artworkUrl = artworkUrl
                    self.historyMO.previewUrl = previewUrl
                    self.historyMO.collectionID = collectionID
                    self.historyMO.collectionName = collectionName
                    self.historyMO.primaryGenreName = primaryGenreName

                    appDelegate.saveContext()
                }
            }

        }

    }
}
