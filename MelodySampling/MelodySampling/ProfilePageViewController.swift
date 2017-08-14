//
//  ProfilePageViewController.swift
//  MelodySampling
//
//  Created by moon on 2017/8/11.
//  Copyright © 2017年 Marvin Lin. All rights reserved.
//

import UIKit

class ProfilePageViewController: UIViewController {

    @IBAction func playButtonTapped(_ sender: Any) {
        print("This button tapped")

        let registerVC = self.storyboard?.instantiateViewController(withIdentifier: "NewTypeChoosePage")

        self.present(registerVC!, animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
