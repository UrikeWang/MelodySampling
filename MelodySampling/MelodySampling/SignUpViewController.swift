//
//  SignUpViewController.swift
//  MelodySampling
//
//  Created by moon on 2017/8/7.
//  Copyright © 2017年 Marvin Lin. All rights reserved.
//

import UIKit
import Firebase
import SwiftyJSON

class SignUpViewController: UIViewController {

    var ref: DatabaseReference!

    var userAccount = ""

    // MARK: Test 以後要改，目前選擇 User + Random No.
    var userFullName = "Test User"

    var profileImageURL = ""

    var seedNumber: Int?

    var addNumber: Int?

    @IBOutlet weak var opacityView: UIView!

    @IBOutlet weak var signUpLabel: UILabel!

    @IBOutlet weak var emailTextField: UITextField!

    @IBOutlet weak var passwordTextField: UITextField!

    @IBOutlet weak var confirmPasswordTextField: UITextField!

    @IBOutlet weak var signUpButtonOutlet: UIButton!

    @IBOutlet weak var goToLoginLabel: UILabel!

    @IBOutlet weak var gotoLoginButonOutlet: UIButton!

    @IBAction func gotoLoginButonTapped(_ sender: UIButton) {

        gotoLoginPage(from: self)
    }

    @IBAction func signUpButtonTapped(_ sender: UIButton) {
        print("Sign up button tapped")

        guard let email = emailTextField.text, let password = passwordTextField.text, let confirmPassword = confirmPasswordTextField.text else { return }

        if email == "" || password == "" || confirmPassword == "" {

            let emptyInputAlert = UIAlertController(title: "Empty field found!", message: "Please input all text field", preferredStyle: .alert)

            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)

            emptyInputAlert.addAction(okAction)

            self.present(emptyInputAlert, animated: true, completion: nil)

        } else {

            if password == confirmPassword {

                self.ref = Database.database().reference()

                Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
                    guard let user = user else {

                        // MARK: 之後再改成跳 UIAlert
                        print("Error occured during register")

                        if let error = error {
                            print(error)
                        }
                        return
                    }

                    let userRef = self.ref.child("users/\(user.uid)")

                    let currentTime = Date().timeIntervalSince1970

                    self.userFullName = "User" + String(2017)

                    userRef.setValue(["fullName": self.userFullName, "createdTime": currentTime, "userAccount": self.userAccount, "profilePicURL": self.profileImageURL, "wasAnonymouse": false])

                    let defaultSetting = self.ref.child("users/defaultSetting")

                    defaultSetting.updateChildValues(["signedUserCount": self.addNumber! + 1])

                    UserDefaults.standard.set(user.uid, forKey: "uid")
                    UserDefaults.standard.set(self.userFullName, forKey:"userName")

                    gotoTypeChoosePage(from: self)

                }
            } else {

                let passwordInputAlert = UIAlertController(title: "Password Input Alert", message: "Please confirm your password again", preferredStyle: .alert)

                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)

                passwordInputAlert.addAction(okAction)

                self.present(passwordInputAlert, animated: true, completion: nil)

            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setCornerRadiustTo(signUpLabel)

        goToLoginLabel.backgroundColor = UIColor.clear

        signUpButtonOutlet.setTitleColor(UIColor.clear, for: .normal)

        gotoLoginButonOutlet.setTitleColor(UIColor.clear, for: .normal)

        self.ref = Database.database().reference()

        let userRef = self.ref.child("users/defaultSetting")

        userRef.observeSingleEvent(of: .value, with: { (snapshot) in

            let json = JSON(snapshot.value as Any)

            self.seedNumber = json["seedNumber"].intValue

            self.addNumber = json["signedUserCount"].intValue

        })
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        createSignUpPageGradient(target: opacityView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
