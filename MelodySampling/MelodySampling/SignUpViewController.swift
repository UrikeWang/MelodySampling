//
//  SignUpViewController.swift
//  MelodySampling
//
//  Created by moon on 2017/7/31.
//  Copyright © 2017年 Marvin Lin. All rights reserved.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController {

    @IBOutlet weak var uIDLabel: UILabel!
    @IBOutlet weak var emailField: UITextField!

    @IBOutlet weak var passwordField: UITextField!

    @IBOutlet weak var confirmPasswordField: UITextField!

    @IBAction func signUpTapped(_ sender: UIButton) {

        guard let email = emailField.text, let password = passwordField.text, let confirmPassword = confirmPasswordField.text else {
            let text = "E-mail 或帳號碼密碼錯誤"

            print(text)

            uIDLabel.text = text

            return
        }

        if password != confirmPassword {

            let text = "兩次輸入的密碼不同"

            print(text)

            uIDLabel.text = text

            return
        }

        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in

            guard let user = user else {
                print("註冊發生錯誤")

                if let error = error {
                    print(error)
                    self.uIDLabel.text = "\(error)"
                }

                return
            }

            let text = "註冊成功"
            print(text)
            print(user.uid)

            self.uIDLabel.text = "\(text)! 你的 uid 是 \(user.uid)"
        }

    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
