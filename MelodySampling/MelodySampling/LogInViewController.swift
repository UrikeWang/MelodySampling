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

    @IBOutlet weak var titleLabel: UILabel!

    @IBOutlet weak var forgetPasswordLabel: UILabel!

    @IBOutlet weak var loginLabel: UILabel!

    @IBOutlet weak var gotoSignUpLabel: UILabel!

    @IBOutlet weak var loginButtonOutlet: UIButton!

    @IBOutlet weak var emailTextField: UITextField!

    @IBOutlet weak var passwordTextField: UITextField!

    @IBOutlet weak var signUpInvisibleButtonOutlet: UIButton!

    @IBOutlet weak var emailResetButtonOutlet: UIButton!

    @IBAction func emailResetButtonTapped(_ sender: UIButton) {

        if emailTextField.text != "" && emailTextField.text != nil {

            guard let email = emailTextField.text else {
                return
            }

            Auth.auth().sendPasswordReset(withEmail: email, completion: { (_) in

                let errorAlert = UIAlertController(title: "Error", message: "Something Wrong, please check your input again", preferredStyle: .alert)

                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)

                errorAlert.addAction(okAction)

                self.present(errorAlert, animated: true, completion: nil)

            })

        } else {

            let errorAlert = UIAlertController(title: "Email is empty!", message: "Please input your email.", preferredStyle: .alert)

            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)

            errorAlert.addAction(okAction)

            self.present(errorAlert, animated: true, completion: nil)

        }
    }

    @IBAction func signUpInvisibleButtonTapped(_ sender: UIButton) {

        guard let loginController = self.storyboard?.instantiateViewController(withIdentifier: "SignupPage") else { return }
        self.navigationController?.pushViewController(loginController, animated: true)
    }

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

                UserDefaults.standard.set(user.uid, forKey: "uid")

                gotoProfilePage(from: self)
            }
        }

    }

    override func viewDidLoad() {
        super.viewDidLoad()

        opacityView.frame = UIScreen.main.bounds

        self.navigationController?.isNavigationBarHidden = false

        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)

        self.navigationController?.navigationBar.shadowImage = UIImage()

        self.navigationController?.navigationBar.isTranslucent = true

        createTitleLabelShadow(target: titleLabel)

        emailResetButtonOutlet.setTitleColor(UIColor.clear, for: .normal)

        forgetPasswordLabel.backgroundColor = UIColor.clear

        setCornerRadiustTo(loginLabel)

        gotoSignUpLabel.backgroundColor = UIColor.clear

        loginButtonOutlet.setTitleColor(UIColor.clear, for: .normal)
        signUpInvisibleButtonOutlet.setTitleColor(UIColor.clear, for: .normal)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if UIScreen.main.bounds.height > 700 {
            createSignUpPageGradient(target: opacityView, height: 750)
        } else {
            createSignUpPageGradient(target: opacityView, height: 680)
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
