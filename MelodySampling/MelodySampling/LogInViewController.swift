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
    @IBOutlet weak var gotoSignUpLabelBottomConstraint: NSLayoutConstraint!
    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    @IBOutlet weak var emailResetButtonOutlet: UIButton!
    @IBAction func emailResetButtonTapped(_ sender: UIButton) {
        if emailTextField.text != "" && emailTextField.text != nil {
            guard let email = emailTextField.text else {
                return
            }
            Auth.auth().sendPasswordReset(withEmail: email, completion: { (_) in

                let errorAlert = UIAlertController(title: NSLocalizedString("Error", comment: "Error title at login page."), message: NSLocalizedString("Something Wrong, please check your input again", comment: "Subtitle of error message at login page."), preferredStyle: .alert)

                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)

                errorAlert.addAction(okAction)

                self.present(errorAlert, animated: true, completion: nil)

            })

        } else {

            let errorAlert = UIAlertController(title: NSLocalizedString("Email is empty!", comment: "Email empty warning"), message: NSLocalizedString("Please input your email.", comment: "Subtitle of email empty warning message"), preferredStyle: .alert)

            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)

            errorAlert.addAction(okAction)

            self.present(errorAlert, animated: true, completion: nil)

        }
    }

    @IBAction func signUpInvisibleButtonTapped(_ sender: UIButton) {

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let destinationViewController = storyboard.instantiateViewController(withIdentifier: "SignupPage")
        
        self.navigationController?.pushViewController(destinationViewController, animated: true)

    }

    @IBAction func loginButtonTapped(_ sender: UIButton) {
        print("Login button tapped")

        guard let email = emailTextField.text, let password = passwordTextField.text else { return }

        if email == "" || password == "" {

            let emptyInputAlert = UIAlertController(title: NSLocalizedString("Empty field found!", comment: "Empty field warning at login page"), message: NSLocalizedString("Please input all text field", comment: "Subtitle of empty field warning at login page."), preferredStyle: .alert)

            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)

            emptyInputAlert.addAction(okAction)

            self.present(emptyInputAlert, animated: true, completion: nil)

        } else {

            Auth.auth().signIn(withEmail: email, password: password) { user, error in

                guard let user = user else {

                    //這裡的 error 之後要重新設計，原始 message 太長
                    if let error = error {

                        let loginErrorAlert = UIAlertController(title: NSLocalizedString("Login Error", comment: "Login error message at login page."), message: "\(error)", preferredStyle: .alert)

                        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)

                        loginErrorAlert.addAction(okAction)

                        self.present(loginErrorAlert, animated: true, completion: nil)

                    }

                    return
                }
                
                let alertController = UIAlertController(title: NSLocalizedString("Network traffic alert", comment: "Network traffic alert title at login page."), message: NSLocalizedString("When you enter the game, there will be internet traffic.", comment: "Network traffic alert message at login page."), preferredStyle: .alert)
                let alertAction = UIAlertAction(title: NSLocalizedString("Resume", comment: "Resume action in alert controller of login page."), style: .default, handler: nil)
                alertController.addAction(alertAction)
                self.present(alertController, animated: true, completion: nil)

                UserDefaults.standard.set(user.uid, forKey: "uid")
                UserDefaults.standard.set(user.isAnonymous, forKey:"isAnonymous")

                print("appdelegate.switchToPlayNavigationController was triggered.")
                
                //swiftlint:disable force_cast
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.switchToPlayNavigationController()
                //swiftlint:enable

            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        titleLabel.text = NSLocalizedString("King of Song Quiz", comment: "Title label at login page.")
        emailTextField.placeholder = NSLocalizedString("Email", comment: "Email textfield placeholder at login page.")
        passwordTextField.placeholder = NSLocalizedString("Password", comment: "Password textfield placeholder at login page.")
        forgetPasswordLabel.text = NSLocalizedString("Forget password", comment: "Forget password label at login page.")
        loginLabel.text = NSLocalizedString("Sign In", comment: "Login label at login page.")
        gotoSignUpLabel.text = NSLocalizedString("Don't have an account? Sign up", comment: "Goto signup page at login page.")

        self.navigationController?.isNavigationBarHidden = true

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
        
        self.hideKeyboardWhenTappedAround()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        /*
        if UIScreen.main.bounds.height > 700 {
            createSignUpPageGradient(target: opacityView, height: 750)
        } else {
            createSignUpPageGradient(target: opacityView, height: 680)
        }
*/
        if UIScreen.main.bounds.height < 600 {

            gotoSignUpLabelBottomConstraint.constant = CGFloat(10)
            self.view.layoutIfNeeded()
        }

    }

    override func viewDidLayoutSubviews() {
        opacityView.frame = UIScreen.main.bounds
        createSignUpPageGradient(target: opacityView, height: Int(UIScreen.main.bounds.height))
    }
}
