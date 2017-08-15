//
//  ProfilePageViewController.swift
//  MelodySampling
//
//  Created by moon on 2017/8/11.
//  Copyright © 2017年 Marvin Lin. All rights reserved.
//

import UIKit

class ProfilePageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var achievementTableView: UITableView!

    @IBOutlet weak var invisibleButton: UIButton!

    @IBAction func invisibleButtonTapped(_ sender: UIButton) {
        print("Play button tapped")

        let registerVC = self.storyboard?.instantiateViewController(withIdentifier: "NewTypeChoosePage")

        self.present(registerVC!, animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        invisibleButton.setTitleColor(UIColor.clear, for: .normal)

        achievementTableView.delegate = self
        achievementTableView.dataSource = self
        // Do any additional setup after loading the view.
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
