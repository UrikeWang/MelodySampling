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

    let userAccount = ""
    
    //MARK: Test 以後要改，目前選擇 User + Random No.
    let userFullName = "Test User"
    
    let profileImageURL = ""
    
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

            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)

            emptyInputAlert.addAction(okAction)

            self.present(emptyInputAlert, animated: true, completion: nil)

        } else {

            if password == confirmPassword {

                //成功才換頁
                
                Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
                    guard let user = user else {
                        
                        //MARK: 之後再改成跳 UIAlert
                        print("Error occured during register")
                        
                        if let error = error {
                            print(error)
                        }
                        return
                    }
                    
                    self.ref = Database.database().reference()
                    
                    let userRef = self.ref.child("users/\(user.uid)")
                    
                    let currentTime = Date().timeIntervalSince1970
                    
                    userRef.setValue(["fullName": self.userFullName, "createdTime": currentTime, "userAccount": self.userAccount, "profilePicURL": self.profileImageURL, "wasAnonymouse": false])
                }
                
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
