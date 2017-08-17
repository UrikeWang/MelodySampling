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

    @IBOutlet weak var invisibleNextGameButtonOutlet: UIButton!
    @IBAction func invisibleNextGameButtonTapped(_ sender: UIButton) {
        gotoTypeChoosePage(from: self)
    }

    @IBOutlet weak var invisibleGoHomeButtonOutlet: UIButton!

    @IBAction func invisibleGoHomeButtonTapped(_ sender: UIButton) {
        gotoProfilePage(from: self)
    }

    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var profilePageView: UIView!

    @IBOutlet weak var lowerView: UIView!

    @IBOutlet weak var nextBattleLabel: UILabel!

    let userDefault = UserDefaults.standard

    @IBOutlet weak var userNameLabel: UILabel!

    var score: Double = 0

    @IBOutlet weak var scoreLabel: UILabel!

    @IBOutlet weak var userProfileImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self

        tableView.dataSource = self

        createProfileViewOfResult(target: self.profilePageView)

        createNextBattleOfResult(target: nextBattleLabel)

        invisibleNextGameButtonOutlet.setTitleColor(UIColor.clear, for: .normal)

        userProfileImageView.layer.shadowColor = UIColor.mldBlack50.cgColor

        userProfileImageView.layer.shadowOffset = CGSize(width: 2, height: 2)

        userProfileImageView.layer.shadowRadius = 4

        if let userName = userDefault.object(forKey: "userName") as? String {
            userNameLabel.text = userName
        } else {
            userNameLabel.text = "This is you"
        }
        invisibleGoHomeButtonOutlet.setTitleColor(UIColor.clear, for: .normal)

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
            let temp = EachSongResult(index: result.index, result: result.result, usedTime: result.usedTime)
            resultsArray.append(temp)

        }
        
        saveResultToHistory()
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

        let fileURL = URL(fileURLWithPath: self.documentsURL.appending("artworkImage\(indexPath.row).jpg"))

        do {
            let data = try Data(contentsOf: fileURL)

            cell.artworkImageView.image = UIImage(data: data)

        } catch {
            print("Using place holder image")
        }

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        let screenSize = UIScreen.main.bounds

        let screenHeight = screenSize.height

        let tableHeight = screenHeight - profilePageView.frame.height - lowerView.frame.height

        return tableHeight / CGFloat(questions.count)
    }

    func saveResultToHistory() {

        var picIndex: Int = 0
        var counter: Double = 1.0
        var imageData: NSData?
        
        for question in self.questions {
            
            var image = UIImage(named: "collectionPlaceHolder")
            
            let fileURL = URL(fileURLWithPath: self.documentsURL.appending("artworkImage\(picIndex).jpg"))
            
            do {
                
                imageData = try NSData(contentsOf: fileURL)
                
//                image = UIImage(data: imageData)
                
            } catch {
                print("image didn't download yet")
            }

            if let artistID = question.artistID, let artistName = question.artistName, let trackID = question.trackID, let trackName = question.trackName, let artworkUrl = question.artworkUrl, let previewUrl = question.previewUrl, let collectionID = question.collectionID, let collectionName = question.collectionName, let primaryGenreName = question.primaryGenreName {

                if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {

                    self.historyMO = HistoryMO(context: appDelegate.persistentContainer.viewContext)

                    self.historyMO.artworkImage = imageData
                    
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
