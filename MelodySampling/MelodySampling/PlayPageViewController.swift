//
//  PlayPageViewController.swift
//  MelodySampling
//
//  Created by moon on 2017/8/8.
//  Copyright © 2017年 Marvin Lin. All rights reserved.
//

import UIKit
import AVFoundation

class PlayPageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var player: AVQueuePlayer?
    
    let path: String = NSHomeDirectory() + "/Documents/"
    
    let fakeArtistList = ["Fake 1", "Fake 2", "Fake 3", "Coorect Artist"]
    
    var questionList: [String]?
    
    @IBOutlet weak var tableView: UITableView!

    @IBAction func playButtonTapped(_ sender: UIButton) {
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self

        tableView.dataSource = self
        
        questionList = fakeArtistList.shuffled()
        
        print(questionList)
        
        tableView.reloadData()
        
        
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questionList!.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cellIdentifier = "Cell"

        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as UITableViewCell
        
        cell.textLabel?.text = questionList?[indexPath.row]

        return cell

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
