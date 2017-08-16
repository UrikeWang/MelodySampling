//
//  ProfilePageViewController.swift
//  MelodySampling
//
//  Created by moon on 2017/8/11.
//  Copyright © 2017年 Marvin Lin. All rights reserved.
//

import UIKit
import Firebase

class ProfilePageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var achievementTableView: UITableView!

    @IBOutlet weak var userProfileImageView: UIImageView!

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

        achievementTableView.delegate = self

        achievementTableView.dataSource = self

        createNextBattleOfResult(target: playButtonLabel)

        createUserProfileImage(targe: userProfileImageView)

        createUserProfilePageLogoutBackground(target: logOutView)

        logOutContentView.backgroundColor = UIColor.clear

        if let userName = UserDefaults.standard.object(forKey: "userName") as? String {
            userNameLabel.text = userName
        } else {
            userNameLabel.text = "This is you"
        }
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cellIdentifier = "HistoryCell"

        let cell = achievementTableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? UITableViewCell

        return cell!

    }

}
