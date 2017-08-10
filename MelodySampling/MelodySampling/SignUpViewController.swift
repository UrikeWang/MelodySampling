//
//  SignUpViewController.swift
//  MelodySampling
//
//  Created by moon on 2017/8/7.
//  Copyright © 2017年 Marvin Lin. All rights reserved.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController {

    var ref: DatabaseReference!

    @IBOutlet weak var opacityView: UIView!

    @IBOutlet weak var signUpLabel: UILabel!

    @IBOutlet weak var emailTextField: UITextField!

    @IBOutlet weak var passwordTextField: UITextField!

    @IBOutlet weak var confirmPasswordTextField: UITextField!

    @IBOutlet weak var signUpButtonOutlet: UIButton!

    @IBOutlet weak var goToLoginLabel: UILabel!

    @IBAction func signUpButtonTapped(_ sender: UIButton) {
        print("Sign up button tapped")

        guard let email = emailTextField.text, let password = passwordTextField.text, let confirmPassword = confirmPasswordTextField.text else { return }

        if email == "" || password == "" || confirmPassword == "" {

            let emptyInputAlert = UIAlertController(title: "Empty field found!", message: "Please input all text field", preferredStyle: .alert)

            let okAction = UIAlertAction(title: "OK", style: .default) {_ in
            }

            emptyInputAlert.addAction(okAction)

            self.present(emptyInputAlert, animated: true, completion: nil)

        } else {

            if password == confirmPassword {

                //成功才換頁
                performSegue(withIdentifier: "goToProfileFromSignUp", sender: nil)

            } else {

                //不成功就跳 UIAlert
                let passwordInputAlert = UIAlertController(title: "Password Input Alert", message: "Please confirm your password again", preferredStyle: .alert)

                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)

                passwordInputAlert.addAction(okAction)

                self.present(passwordInputAlert, animated: true, completion: nil)
            }

        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        createSignUpPageGradient(target: opacityView)

        setCornerRadiustTo(signUpLabel)

        goToLoginLabel.backgroundColor = UIColor.clear

        signUpButtonOutlet.setTitleColor(UIColor.clear, for: .normal)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
