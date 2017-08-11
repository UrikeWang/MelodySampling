//
//  ResultPageViewController.swift
//  MelodySampling
//
//  Created by moon on 2017/8/11.
//  Copyright © 2017年 Marvin Lin. All rights reserved.
//

import UIKit

class ResultPageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var invisibleNextGameButtonOutlet: UIButton!
    
    @IBOutlet weak var invisibleGoHomeButtonOutlet: UIButton!
    
    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var profilePageView: UIView!

    @IBOutlet weak var lowerView: UIView!

    var songList = ["a", "b", "c", "d", "e"]

    @IBOutlet weak var nextBattleLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self

        tableView.dataSource = self

        createProfileViewOfResult(target: self.profilePageView)

        createNextBattleOfResult(target: nextBattleLabel)
        
        invisibleNextGameButtonOutlet.setTitleColor(UIColor.clear, for: .normal)

        invisibleGoHomeButtonOutlet.setTitleColor(UIColor.clear, for: .normal)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cellIdentifier = "ResultCell"

        //swiftlint:disable force_cast
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! ResultTableViewCell
        //swiftlint:enable

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        let screenSize = UIScreen.main.bounds

        let screenHeight = screenSize.height

        let tableHeight = screenHeight - profilePageView.frame.height - lowerView.frame.height

        return tableHeight / CGFloat(songList.count)
    }
}
