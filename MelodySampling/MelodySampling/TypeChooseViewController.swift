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

//    var typeList = ["國語歌曲", "台語歌曲", "男女對唱", "熱門排行"]
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

        switch genre {

        case .mandarinPop:

            cell.backgroundImageView.image = UIImage(named: "pic_Cpop_cover")

            cell.genreTypeLabel.text = "華語流行"

        case .taiwanesePop:

            cell.backgroundImageView.image = UIImage(named: "pic_Tpop_cover")

            cell.genreTypeLabel.text = "台語流行"

        case .cantoPop:

            cell.backgroundImageView.image = UIImage(named: "pic_Can_cover")

            cell.genreTypeLabel.text = "粵語流行"

        case .billboard:

            cell.backgroundImageView.image = UIImage(named: "pic_Wpop_cover")

            cell.genreTypeLabel.text = "世界流行"

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
