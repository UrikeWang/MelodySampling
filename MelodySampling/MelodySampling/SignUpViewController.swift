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

    @IBOutlet weak var signUpButtonOutlet: UIButton!

    @IBAction func signUpButtonTapped(_ sender: UIButton) {
        print("Sign up button tapped")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        createSignUpPageGradient(target: opacityView)

        setCornerRadiustTo(signUpLabel)

        signUpButtonOutlet.setTitleColor(UIColor.clear, for: .normal)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
