//
//  PlayPageViewController.swift
//  MelodySampling
//
//  Created by moon on 2017/8/10.
//  Copyright © 2017年 Marvin Lin. All rights reserved.
//

import UIKit

class PlayPageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!

    var shuffledList = ["A", "B", "C", "D"]

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self

        tableView.dataSource = self
        
        self.tableView.backgroundColor = UIColor.clear
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return shuffledList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "AnswerCell"
        
        //swiftlint:disable force_cast
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! AnswerTableViewCell
        
        cell.answerLabel.text = shuffledList[indexPath.section]
        //swiftlint:enable
        cell.backgroundColor = UIColor.clear
        
        
        return cell
        
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 79
    }

}
