//
//  ProfilePageViewController.swift
//  MelodySampling
//
//  Created by moon on 2017/8/11.
//  Copyright © 2017年 Marvin Lin. All rights reserved.
//

import UIKit
import Firebase
import CoreData

class ProfilePageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {

    @IBOutlet weak var historyTableView: UITableView!

    @IBOutlet weak var userProfileImageView: UIImageView!
    var fetchResultController: NSFetchedResultsController<HistoryMO>!

    var historyList: [HistoryMO] = []

    @IBOutlet weak var playButtonLabel: UILabel!

    @IBOutlet weak var playTextLabel: UILabel!

    @IBOutlet weak var invisibleButton: UIButton!

    @IBOutlet weak var logOutView: UIView!

    @IBOutlet weak var logOutContentView: UIView!

    @IBOutlet weak var logOutButtonOutlet: UIButton!

    @IBOutlet weak var userNameLabel: UILabel!

    @IBAction func logOutButtonTapped(_ sender: UIButton) {

        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }

        let userDefault = UserDefaults.standard

        let keysInArray = Array(userDefault.dictionaryRepresentation().keys)

        for each in keysInArray {
            userDefault.removeObject(forKey: "\(each)")
        }

        let checkCoredata = CheckQuestionInCoreData()

        checkCoredata.clearHistoryMO()

        gotoLandingPage(from: self)

    }

    @IBAction func invisibleButtonTapped(_ sender: UIButton) {
        print("Play button tapped")

        gotoTypeChoosePage(from: self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        checkUID()

        logOutButtonOutlet.setTitleColor(UIColor.clear, for: .normal)

        invisibleButton.setTitleColor(UIColor.clear, for: .normal)

        historyTableView.delegate = self

        historyTableView.dataSource = self

        createNextBattleOfResult(target: playButtonLabel)

        createUserProfileImage(targe: userProfileImageView)

        createUserProfilePageLogoutBackground(target: logOutView)

        logOutContentView.backgroundColor = UIColor.clear

        if let userName = UserDefaults.standard.object(forKey: "userName") as? String {
            userNameLabel.text = userName
        } else {
            userNameLabel.text = "This is you"
        }

        let fetchRequest: NSFetchRequest<HistoryMO> = HistoryMO.fetchRequest()

        let sortDescriptor = NSSortDescriptor(key: "timeIndex", ascending: true)

        fetchRequest.sortDescriptors = [sortDescriptor]

        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {

            let context = appDelegate.persistentContainer.viewContext

            fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)

            fetchResultController.delegate = self

            do {

                try fetchResultController.performFetch()

                if let fetchedObjects = fetchResultController.fetchedObjects {

                    historyList = fetchedObjects

                    historyTableView.reloadData()

                }

            } catch {
                historyList = []
                print(error)
            }

        }

        if historyList.count == 0 {

            let framOfTableView = self.historyTableView.frame

            let emptyView = UIView(frame: framOfTableView)

            createProfilePageHistoryCellBackground(target: emptyView)

            let emptyLabel = createLabel(at: emptyView, content: "尚無對戰紀錄", color: UIColor.white, font: UIFont.mldTextStyleEmptyFont()!)

            self.view.addSubview(emptyView)

            self.view.addSubview(emptyLabel)

        }

    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return historyList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cellIdentifier = "HistoryCell"

        //swiftlint:disable force_cast
        let cell = historyTableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! HistoryTableViewCell
        //swiftlint:enable

        cell.artistNameLabel.text = historyList[indexPath.row].artistName
        cell.trackNameLabel.text = historyList[indexPath.row].trackName

        return cell

    }

}
