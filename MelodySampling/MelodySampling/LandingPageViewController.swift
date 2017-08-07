//
//  LandingPageViewController.swift
//  MelodySampling
//
//  Created by moon on 2017/8/7.
//  Copyright © 2017年 Marvin Lin. All rights reserved.
//

import UIKit

class LandingPageViewController: UIViewController {

    @IBOutlet weak var loginLabel: UILabel!

    @IBOutlet weak var signupLabel: UILabel!

    @IBOutlet weak var anonymousLoginLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        setCornerRadiustTo(loginLabel)
        loginLabel.layer.borderColor = UIColor.white.cgColor
        loginLabel.layer.borderWidth = 2

        setCornerRadiustTo(signupLabel)

        setCornerRadiustTo(anonymousLoginLabel)

        createGradientOnLabel(target: anonymousLoginLabel)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
