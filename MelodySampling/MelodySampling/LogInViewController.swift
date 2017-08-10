//
//  LogInViewController.swift
//  MelodySampling
//
//  Created by moon on 2017/8/7.
//  Copyright © 2017年 Marvin Lin. All rights reserved.
//

import UIKit
import Firebase

class LogInViewController: UIViewController {

    @IBOutlet weak var opacityView: UIView!

    @IBOutlet weak var forgetPasswordLabel: UILabel!

    @IBOutlet weak var loginLabel: UILabel!

    @IBOutlet weak var gotoSignUpLabel: UILabel!

    @IBOutlet weak var loginButtonOutlet: UIButton!

    @IBOutlet weak var emailTextField: UITextField!

    @IBOutlet weak var passwordTextField: UITextField!

    @IBAction func loginButtonTapped(_ sender: UIButton) {
        print("Login button tapped")

        guard let email = emailTextField.text, let password = passwordTextField.text else { return }

        if email == "" || password == "" {

            let emptyInputAlert = UIAlertController(title: "Empty field found!", message: "Please input all text field", preferredStyle: .alert)

            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)

            emptyInputAlert.addAction(okAction)

            self.present(emptyInputAlert, animated: true, completion: nil)

        } else {

            Auth.auth().signIn(withEmail: email, password: password) { user, error in

                guard let user = user else {

                    
                    //這裡的 error 之後要重新設計，原始 message 太長
                    if let error = error {

                        let loginErrorAlert = UIAlertController(title: "Login Error", message: "\(error)", preferredStyle: .alert)

                        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)

                        loginErrorAlert.addAction(okAction)

                        self.present(loginErrorAlert, animated: true, completion: nil)

                    }

                    return
                }

                // MARK: 這個 segue 是暫時的，之後用 RootViewController 的方式過場
                self.performSegue(withIdentifier: "goToProfileFromLogin", sender: self)
            }
        }

    }

    override func viewDidLoad() {
        super.viewDidLoad()

        createSignUpPageGradient(target: opacityView)

        forgetPasswordLabel.backgroundColor = UIColor.clear

        setCornerRadiustTo(loginLabel)

        gotoSignUpLabel.backgroundColor = UIColor.clear

        loginButtonOutlet.setTitleColor(UIColor.clear, for: .normal)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
