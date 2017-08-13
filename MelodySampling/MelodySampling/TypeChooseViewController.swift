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

    var typeList = ["國語歌曲", "台語歌曲", "男女對唱", "熱門排行"]

    @IBOutlet weak var tableView: UITableView!

    @IBAction func playButtonTapped(_ sender: UIButton) {

        print("開始抓題庫了")

        DispatchQueue.main.async {

            downloadQuestion(genre: 1, viewController: self)
        }
    }

    @IBAction func checkButtonTapped(_ sender: UIButton) {

        let fileManager = FileManager()

        do {
            let fileList = try fileManager.contentsOfDirectory(atPath: NSHomeDirectory() + "/Documents/")

            for file in fileList {
                print(file)
            }
        } catch {
            print("Something wrong during loading")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self

        tableView.dataSource = self

        // Do any additional setup after loading the view.
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

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        // MARK: 之後把過場和選提寫在這
        print("你選了 \(typeList[indexPath.row])")

    }

}
