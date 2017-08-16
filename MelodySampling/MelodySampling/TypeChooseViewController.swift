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
import Crashlytics

class TypeChooseViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var ref: DatabaseReference!

    @IBOutlet weak var userIconBackgroundView: UIView!

    @IBOutlet weak var invisibleButton: UIButton!

    @IBOutlet weak var tableView: UITableView!
    
    

    enum TypeList {
        case mandarinPop, taiwanesePop, cantoPop, billboard
    }

    var typeList: [TypeList] = [.mandarinPop, .taiwanesePop, .cantoPop, .billboard]

    override func viewDidLoad() {
        super.viewDidLoad()

        checkUID()

        tableView.delegate = self

        tableView.dataSource = self

        userIconBackgroundView.layer.cornerRadius = 30
        
        userIconBackgroundView.layer.masksToBounds = true
        
        invisibleButton.setTitleColor(UIColor.clear, for: .normal)
        
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
        cell.genreButtonOutlet.titleLabel?.font = UIFont.mldTextStyle10Font()
        cell.genreButtonOutlet.setTitleShadowColor(UIColor.mldSapphire, for: .normal)
        cell.genreButtonOutlet.titleLabel?.layer.shadowRadius = 4
        cell.genreButtonOutlet.titleLabel?.layer.shadowOffset = CGSize(width: 0, height: 10)
        cell.genreButtonOutlet.titleLabel?.layer.shadowOpacity = 1

        switch genre {

        case .mandarinPop:

            cell.backgroundImageView.image = UIImage(named: "pic_Cpop_new")

            cell.genreButtonOutlet.setTitle("華語流行", for: .normal)

        case .taiwanesePop:

            cell.backgroundImageView.image = UIImage(named: "pic_Tpop_new")

            cell.genreButtonOutlet.setTitle("台語流行", for: .normal)

        case .cantoPop:

            cell.backgroundImageView.image = UIImage(named: "pic_Can_new")

            cell.genreButtonOutlet.setTitle("粵語流行", for: .normal)

        case .billboard:

            cell.backgroundImageView.image = UIImage(named: "pic_Wpop_new")

            cell.genreButtonOutlet.setTitle("世界流行", for: .normal)

        }

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return self.tableView.frame.height / CGFloat(typeList.count)
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        // MARK: 之後把過場和選提寫在這
        print("你選了 \(typeList[indexPath.row])")

        triggerToStart()

    }

    func triggerToStart() {

        DispatchQueue.main.async {

            let checkQuestion = CheckQuestionInCoreData()

            checkQuestion.clearQuestionMO()

            checkQuestion.clearResultMO()

            let downloadManager = DownloadManager()

            downloadManager.downloadQuestion(genre: 1, viewController: self)

        }

    }

}
