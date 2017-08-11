//
//  TypeChoosePageViewController.swift
//  MelodySampling
//
//  Created by moon on 2017/8/11.
//  Copyright © 2017年 Marvin Lin. All rights reserved.
//

import UIKit

class TypeChoosePageViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var typeList = ["男歌手", "女歌手", "團體歌手", "單人歌手"]

    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self

        tableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return typeList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cellIdentifier = "TypeCell"

        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        
        cell.textLabel?.text = typeList[indexPath.row]

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return self.tableView.frame.height / CGFloat(typeList.count)

    }
}
