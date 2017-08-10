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

        if emailTextField.text == "" || passwordTextField.text == "" || confirmPasswordTextField.text == "" {

            let emptyInputAlert = UIAlertController(title: "Empty field found!", message: "Please input all text field", preferredStyle: .alert)

            let okAction = UIAlertAction(title: "Got it", style: .default) {_ in
            }

            emptyInputAlert.addAction(okAction)

            self.present(emptyInputAlert, animated: true, completion: nil)

        } else {

           print("start judge")

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
