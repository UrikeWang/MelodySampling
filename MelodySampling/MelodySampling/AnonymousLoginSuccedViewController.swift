//
//  AnonymousLoginSuccedViewController.swift
//  MelodySampling
//
//  Created by moon on 2017/7/31.
//  Copyright © 2017年 Marvin Lin. All rights reserved.
//

import UIKit
import Firebase

class AnonymousLoginSuccedViewController: UIViewController {

    @IBOutlet weak var resultLabel: UILabel!

    @IBOutlet weak var emailTextField: UITextField!

    @IBOutlet weak var passwordTextField: UITextField!

    @IBAction func signUpTapped(_ sender: UIButton) {

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //不知道為什麼，當判斷使用者是不是 anonymous 放在 ViewDidLoad 就是不會直接觸發

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if let user = Auth.auth().currentUser {

            if user.isAnonymous {
                print("使用者用暱名登入")
                resultLabel.text = "使用者用暱名登入"
            }
        }
    }
}
