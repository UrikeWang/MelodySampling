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

    var questions: [QuestionMO] = []

    var results: [ResultMO] = []

    var trackNameArray = [String]()

    var artistNameArray = [String]()

    var resultsArray = [EachSongResult]()

    @IBOutlet weak var invisibleNextGameButtonOutlet: UIButton!

    @IBOutlet weak var invisibleGoHomeButtonOutlet: UIButton!

    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var profilePageView: UIView!

    @IBOutlet weak var lowerView: UIView!

    @IBOutlet weak var nextBattleLabel: UILabel!

    let userDefault = UserDefaults.standard

    var score: Double = 0

    @IBOutlet weak var scoreLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self

        tableView.dataSource = self

        createProfileViewOfResult(target: self.profilePageView)

        createNextBattleOfResult(target: nextBattleLabel)

        invisibleNextGameButtonOutlet.setTitleColor(UIColor.clear, for: .normal)

        invisibleGoHomeButtonOutlet.setTitleColor(UIColor.clear, for: .normal)

        score = (userDefault.object(forKey: "Score") as? Double)!

        scoreLabel.text = "\(String(format: "%.0f", score))"

        let fetchQuestionRequest: NSFetchRequest<QuestionMO> = QuestionMO.fetchRequest()

        let fetchResultsRequest: NSFetchRequest<ResultMO> = ResultMO.fetchRequest()

        let sortDescriptor = NSSortDescriptor(key: "artistID", ascending: true)

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
            if let trackName = question.trackName, let artistName = question.artistName {
                trackNameArray.append(trackName)
                artistNameArray.append(artistName)
                print(trackName, artistName)
            }
        }

        for result in results {
            let temp = EachSongResult(index: result.index, result: result.result, usedTime: result.usedTime)
            resultsArray.append(temp)

        }
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

        let documentsURL = NSHomeDirectory() + "/Documents/"
        let fileURL = URL(fileURLWithPath: documentsURL.appending("artworkImage\(indexPath.row).jpg"))

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
}
