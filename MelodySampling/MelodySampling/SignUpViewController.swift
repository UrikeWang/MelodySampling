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

    var ref: DatabaseReference!

    let userAccount = ""

    let userFullName = "Test User"

    let profileImageURL = ""

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

            self.ref = Database.database().reference()

            let userRef = self.ref.child("users/\(user.uid)")

            let currentTime = Date().timeIntervalSince1970

            userRef.setValue(["uid": user.uid, "fullName": self.userFullName, "createdTime": currentTime, "userAccount": self.userAccount, "profilePicURL": self.profileImageURL])

        }

        performSegue(withIdentifier: "showLoginSuccess", sender: self)
    }

    @IBAction func anonymouseLoginTapped(_ sender: UIButton) {

        Auth.auth().signInAnonymously { (user, error) in

            guard let user = user else {
                if let error = error {
                    print(error)
                    self.uIDLabel.text = "\(error)"
                }
                return
            }

            let isAnonymous = user.isAnonymous

            self.ref = Database.database().reference()

            let anonymousRef = self.ref.child("anonymousUsers/\(user.uid)")

            let currentTime = Date().timeIntervalSince1970

            anonymousRef.setValue(["uid": user.uid, "createdTime": currentTime, "isAnonymous": isAnonymous])

        }

        performSegue(withIdentifier: "anonymousLogin", sender: self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
