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

    var fetchResultController: NSFetchedResultsController<QuestionMO>!

    var questions: [QuestionMO] = []

    var trackNameArray = [String]()

    var artistNameArray = [String]()

    @IBOutlet weak var invisibleNextGameButtonOutlet: UIButton!

    @IBOutlet weak var invisibleGoHomeButtonOutlet: UIButton!

    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var profilePageView: UIView!

    @IBOutlet weak var lowerView: UIView!

    var songList = ["a", "b", "c", "d", "e"]

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

        for question in questions {
            if let trackName = question.trackName, let artistName = question.artistName {
                trackNameArray.append(trackName)
                artistNameArray.append(artistName)
                print(trackName, artistName)
            }
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cellIdentifier = "ResultCell"

        //swiftlint:disable force_cast
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! ResultTableViewCell
        //swiftlint:enable

        cell.trackNameLabel.text = "\(trackNameArray[indexPath.row])"
        cell.artistNameLabel.text = "\(artistNameArray[indexPath.row])"
        
        let documentsURL = NSHomeDirectory() + "/Documents/"
        let fileURL = URL(fileURLWithPath: documentsURL.appending("artworkImage\(indexPath.row).jpg"))
        
        do {
            let data = try Data(contentsOf: fileURL)
            
            cell.artworkImageView.image = UIImage(data: data)
        
        } catch {
            print("Using place holder image")
        }
        
//        cell.artworkImageView.image = UIImage(data: Data(contentsOf: fileURL))
        

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        let screenSize = UIScreen.main.bounds

        let screenHeight = screenSize.height

        let tableHeight = screenHeight - profilePageView.frame.height - lowerView.frame.height

        return tableHeight / CGFloat(songList.count)
    }
}
