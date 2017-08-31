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

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var opacityView: UIView!

    @IBOutlet weak var signUpLabel: UILabel!

    @IBOutlet weak var emailTextField: UITextField!

    @IBOutlet weak var passwordTextField: UITextField!

    @IBOutlet weak var confirmPasswordTextField: UITextField!

    @IBOutlet weak var signUpButtonOutlet: UIButton!

    @IBOutlet weak var goToLoginLabel: UILabel!

    @IBOutlet weak var gotoLoginLabelBottomConstrain: NSLayoutConstraint!

    @IBAction func backButtonTapped(_ sender: UIButton) {

        self.dismiss(animated: true) { _ in
            gotoLandingPage(from: self)
        }

    }

    @IBOutlet weak var gotoLoginButonOutlet: UIButton!

    @IBAction func gotoLoginButonTapped(_ sender: UIButton) {

            gotoLoginPage(from: self)

    }

    @IBAction func signUpButtonTapped(_ sender: UIButton) {
        print("Sign up button tapped")

        guard let email = emailTextField.text, let password = passwordTextField.text, let confirmPassword = confirmPasswordTextField.text else { return }

        if email == "" || password == "" || confirmPassword == "" {

            let emptyInputAlert = UIAlertController(title: NSLocalizedString("Empty field found!", comment: "Empty field warning at signup page"), message: NSLocalizedString("Please input all text field", comment: "Subtitle of empty field warning at signup page."), preferredStyle: .alert)

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

                            let warningAlert = UIAlertController(title: NSLocalizedString("Something Wrong", comment: "Sign up error message at signup page"), message: NSLocalizedString("Please check email, password, confirm passwork again.", comment: "Subtitle of sign up error message at signup page."), preferredStyle: .alert)

                            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)

                            warningAlert.addAction(okAction)

                            self.present(warningAlert, animated: true, completion: nil)

                        }
                        return
                    }

                    let userRef = self.ref.child("users/\(user.uid)")

                    let currentTime = Date().timeIntervalSince1970

                    let randomNumber = random(9999)

                    let formatRandom = String(format: "%06i", randomNumber)

                    self.userFullName = NSLocalizedString("User", comment: "for user label") + formatRandom

                    userRef.setValue(["fullName": self.userFullName, "createdTime": currentTime, "userAccount": self.userAccount, "profilePicURL": self.profileImageURL, "wasAnonymouse": false])

                    // MARK: I am going to fix these later
                    /*
                    let defaultSetting = self.ref.child("users/defaultSetting")

                    defaultSetting.updateChildValues(["signedUserCount": self.addNumber! + 1])

 */
                    UserDefaults.standard.set(user.uid, forKey: "uid")
                    UserDefaults.standard.set(self.userFullName, forKey:"userName")
                    gotoTypeChoosePage(from: self)

                }
            } else {

                let passwordInputAlert = UIAlertController(title: NSLocalizedString("Password Input Alert", comment: "Password input alert at signup page"), message: NSLocalizedString("Please confirm your password again", comment: "Confirm password again at signup page."), preferredStyle: .alert)

                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)

                passwordInputAlert.addAction(okAction)

                self.present(passwordInputAlert, animated: true, completion: nil)

            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        titleLabel.text = NSLocalizedString("King of Song Quiz", comment: "Title Label of Sign Up Page")
        emailTextField.placeholder = NSLocalizedString("Email", comment: "Email textfield placeholder at signup page.")
        passwordTextField.placeholder = NSLocalizedString("Password", comment: "Password textfield placeholder at signup page.")
        confirmPasswordTextField.placeholder = NSLocalizedString("Confirm Password", comment: "Confirm Password at signup page")
        signUpLabel.text = NSLocalizedString("Sign up", comment: "Signup label at signup page.")
        goToLoginLabel.text = NSLocalizedString("Already have an account? Log in", comment: "Goto login page at signup page.")
        
        opacityView.frame = UIScreen.main.bounds

        self.navigationController?.isNavigationBarHidden = false

        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)

        self.navigationController?.navigationBar.shadowImage = UIImage()

        self.navigationController?.navigationBar.isTranslucent = true

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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if UIScreen.main.bounds.height > 700 {
           createSignUpPageGradient(target: opacityView, height: 750)
         } else {
            createSignUpPageGradient(target: opacityView, height: 700)
        }

        if UIScreen.main.bounds.height < 600 {
            gotoLoginLabelBottomConstrain.constant = CGFloat(10)

            self.view.layoutIfNeeded()
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
