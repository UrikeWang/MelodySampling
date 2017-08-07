//
//  SignUpViewController.swift
//  MelodySampling
//
//  Created by moon on 2017/8/7.
//  Copyright © 2017年 Marvin Lin. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {

    @IBOutlet weak var opacityView: UIView!

    @IBOutlet weak var signUpLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        createSignUpPageGradient(target: opacityView)

        setCornerRadiustTo(signUpLabel)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
