//
//  LandingPageViewController.swift
//  MelodySampling
//
//  Created by moon on 2017/8/7.
//  Copyright © 2017年 Marvin Lin. All rights reserved.
//

import UIKit
import Firebase

class LandingPageViewController: UIViewController {
    
    var ref: DatabaseReference!

    @IBOutlet weak var loginLabel: UILabel!

    @IBOutlet weak var signupLabel: UILabel!

    @IBOutlet weak var anonymousLoginLabel: UILabel!

    @IBOutlet weak var loginButtonOutlet: UIButton!

    @IBAction func loginButtonTapped(_ sender: UIButton) {
        print("Login button tapped")
    }

    @IBOutlet weak var signUpButtonOutlet: UIButton!

    @IBAction func signUpButtonTapped(_ sender: UIButton) {
        print("SignUp button tapped")
    }

    @IBOutlet weak var anonymousLoginButtonOutlet: UIButton!

    @IBAction func anonymousLoginButtonTapped(_ sender: UIButton) {
        print("Anonymous login button tapped")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setCornerRadiustTo(loginLabel)
        loginLabel.layer.borderColor = UIColor.white.cgColor
        loginLabel.layer.borderWidth = 2
        loginLabel.backgroundColor = UIColor.clear

        setCornerRadiustTo(signupLabel)

        setCornerRadiustTo(anonymousLoginLabel)

        createGradientOnLabel(target: anonymousLoginLabel)

        loginButtonOutlet.setTitleColor(UIColor.clear, for: .normal)

        signUpButtonOutlet.setTitleColor(UIColor.clear, for: .normal)

        anonymousLoginButtonOutlet.setTitleColor(UIColor.clear, for: .normal)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
