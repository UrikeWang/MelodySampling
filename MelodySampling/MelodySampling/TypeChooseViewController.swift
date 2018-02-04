//
//  NewTypeChooseViewController.swift
//  MelodySampling
//
//  Created by moon on 2017/8/11.
//  Copyright © 2017年 Marvin Lin. All rights reserved.
//

import UIKit
import Alamofire
import Firebase

class TypeChooseViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var ref: DatabaseReference!
    
    let randomUserManager = RandomUserManager()

    @IBOutlet weak var userIconBackgroundView: UIView!

    @IBOutlet weak var invisibleButton: UIButton!
    
    @IBAction func invisibleButtonTapped(_ sender: UIButton) {
        
        print("popToRootViewController func triggered")
        
        userIconBackgroundView.isHidden = true
        self.navigationController?.popToRootViewController(animated: true)
        
    }

    @IBOutlet weak var tableView: UITableView!

    var questionCounter: Int?

    enum TypeList: String {
        case mandarinPop, taiwanesePop, cantoPop, billboardPop
    }

    var typeList: [TypeList] = [.mandarinPop, .taiwanesePop, .cantoPop, .billboardPop]

    override func viewDidLoad() {
        super.viewDidLoad()

        print("===== =====")

        self.questionCounter = UserDefaults.standard.object(forKey: "questionCounter") as? Int ?? 1

        tableView.delegate = self
        tableView.dataSource = self
        
        userIconBackgroundView.layer.cornerRadius = 30
        userIconBackgroundView.layer.masksToBounds = true

        invisibleButton.setTitleColor(UIColor.clear, for: .normal)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let delayTime = DispatchTime.now() + .milliseconds(350)
        DispatchQueue.main.asyncAfter(deadline: delayTime, execute: {
            self.userIconBackgroundView.isHidden = false
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return typeList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cellIdentifier = "GenreCell"

        //swiftlint:disable force_cast
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! StandardTableViewCell
        //swiftlint:enable

        cell.selectionStyle = .none

        let genre = typeList[indexPath.row]

        cell.genreTypeLabel.text = ""

        cell.genreButtonOutlet.setTitleColor(UIColor.white, for: .normal)
//        cell.genreButtonOutlet.titleLabel?.font = UIFont.mldTextStyle10Font()
        cell.genreButtonOutlet.setTitleShadowColor(UIColor.mldSapphire, for: .normal)
        cell.genreButtonOutlet.titleLabel?.layer.shadowRadius = 4
        cell.genreButtonOutlet.titleLabel?.layer.shadowOffset = CGSize(width: 0, height: 4)
        cell.genreButtonOutlet.titleLabel?.layer.shadowOpacity = 1

        switch genre {

        case .mandarinPop:

            cell.backgroundImageView.image = UIImage(named: "pic_Cpop_new")

            cell.genreButtonOutlet.setTitle(NSLocalizedString("Mandarin Pop", comment: "Mandarin pop cell at genre type choose page."), for: .normal)

        case .taiwanesePop:

            cell.backgroundImageView.image = UIImage(named: "pic_Tpop_new")

            cell.genreButtonOutlet.setTitle(NSLocalizedString("Taiwanese Pop", comment: "Taiwanese pop cell at genre type choose page."), for: .normal)

        case .cantoPop:

            cell.backgroundImageView.image = UIImage(named: "pic_Can_new")

            cell.genreButtonOutlet.setTitle(NSLocalizedString("Cantonese Pop", comment: "Cantonese pop cell at genre type choose page."), for: .normal)

        case .billboardPop:

            cell.backgroundImageView.image = UIImage(named: "pic_Wpop_new")

            cell.genreButtonOutlet.setTitle(NSLocalizedString("Billboard Pop", comment: "Billboard pop cell at genre type choose page."), for: .normal)

        }

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return UIScreen.main.bounds.height / CGFloat(typeList.count)
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let languageSelected = typeList[indexPath.row].rawValue

        Analytics.logEvent("GenreOfUserChoosed", parameters: [languageSelected: languageSelected as NSObject])

        Analytics.logEvent("GenreWhichUserChoosed", parameters: ["Genre": languageSelected as NSObject])

        UserDefaults.standard.set(languageSelected, forKey: "selectedGenre")

        triggerToStart(selected: languageSelected)

    }

    func triggerToStart(selected language: String) {

        // MARK: Delete CoreData code aft 1.1.10 or later
        let checkQuestion = CheckQuestionInCoreData()

        checkQuestion.clearQuestionMO()

        checkQuestion.clearResultMO()

        let downloadManager = DownloadManager()
        
        randomUserManager.requestAUser()
        
        print("開始要求 npc")
        
        var trackCounter: Int
        
        if let unwrapCounter = UserDefaults.standard.object(forKey: "trackCounter") as? Int {
            
            trackCounter = unwrapCounter
            
        } else {
            trackCounter = 1200
        }
        
        print("trackCounter: \(trackCounter)")

        downloadManager.downloadRandomQuestion(selected: language, max: trackCounter, viewController: self)

    }
}
