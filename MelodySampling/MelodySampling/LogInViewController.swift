//
//  LogInViewController.swift
//  MelodySampling
//
//  Created by moon on 2017/8/7.
//  Copyright © 2017年 Marvin Lin. All rights reserved.
//

import UIKit

class LogInViewController: UIViewController {

    @IBOutlet weak var opacityView: UIView!

    @IBOutlet weak var forgetPasswordLabel: UILabel!

    @IBOutlet weak var loginLabel: UILabel!

    @IBOutlet weak var gotoSignUpLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        createSignUpPageGradient(target: opacityView)

        forgetPasswordLabel.backgroundColor = UIColor.clear

        setCornerRadiustTo(loginLabel)

        gotoSignUpLabel.backgroundColor = UIColor.clear
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
