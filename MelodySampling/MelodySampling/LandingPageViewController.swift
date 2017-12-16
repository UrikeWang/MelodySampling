//
//  LandingPageViewController.swift
//  MelodySampling
//
//  Created by moon on 2017/8/7.
//  Copyright © 2017年 Marvin Lin. All rights reserved.
//

import UIKit
import Firebase
import SwiftyJSON

class LandingPageViewController: UIViewController {

    var ref: DatabaseReference!

    var seedNumber: Int?

    var addNumber: Int?

    var startTime: Double?

    var userFullName = ""

    @IBOutlet weak var titleLabel: UILabel!

    @IBOutlet weak var loginLabel: UILabel!

    @IBOutlet weak var signupLabel: UILabel!

    @IBOutlet weak var anonymousLoginLabel: UILabel!

    @IBOutlet weak var anonymousLoginTextLabel: UILabel!

    @IBOutlet weak var loginButtonOutlet: UIButton!

    @IBAction func loginButtonTapped(_ sender: UIButton) {

        print("Login button tapped")

        let currentTime = Date().timeIntervalSince1970

        guard let startTime = self.startTime else { return }

//        gotoLoginPage(from: self)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let destinationViewController = storyboard.instantiateViewController(withIdentifier: "LoginPage")
        
        self.navigationController?.pushViewController(destinationViewController, animated: true)
        
        Analytics.logEvent("UserGotoLoginPage", parameters: ["timePassed": currentTime - startTime])

    }

    @IBOutlet weak var signUpButtonOutlet: UIButton!

    @IBAction func signUpButtonTapped(_ sender: UIButton) {

        print("Sign up button tapped")

        let currentTime = Date().timeIntervalSince1970

        guard let startTime = self.startTime else { return }

//        gotoSignupPage(from: self)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let destinationViewController = storyboard.instantiateViewController(withIdentifier: "SignupPage")
        
        self.navigationController?.pushViewController(destinationViewController, animated: true)

        Analytics.logEvent("UserGotoSignUpPage", parameters: ["timePassed": currentTime - startTime])
    }

    @IBOutlet weak var anonymousLoginButtonOutlet: UIButton!

    @IBAction func anonymousLoginButtonTapped(_ sender: UIButton) {
        print("Anonymous login button tapped")

        self.anonymousLoginButtonOutlet.isEnabled = false

        Auth.auth().signInAnonymously { (user, error) in

            guard let user = user else {
                if let error = error {
                    print(error)

                    self.anonymousLoginButtonOutlet.isEnabled = true
                }
            return

            }

            let isAnonymous = user.isAnonymous

            self.ref = Database.database().reference()

            let anonymousRef = self.ref.child("anonymousUsers/\(user.uid)")

            //歷史錯誤,以前在設定資料庫的時候,把 anonymousUsers 加入

            let currentTime = Date().timeIntervalSince1970

            self.userFullName = "Anonymous"

            anonymousRef.setValue([
                "createdTime": currentTime,
                "isAnonymous": isAnonymous,
                "fullName": self.userFullName
                ])

            let userRef = self.ref.child("users/\(user.uid)")

            userRef.setValue([
                "createdTime": currentTime,
                "isAnonymous": isAnonymous,
                "fullName": self.userFullName,
                "wasAnonymous": true,
                "userAccount": "",
                "profilePicURL": ""
                ])

            print("\(user.uid) was registered")

            UserDefaults.standard.set(user.uid, forKey: "uid")
            UserDefaults.standard.set(NSLocalizedString("Anonymous", comment: "User name of who logged in anonymously"), forKey: "userName")
            UserDefaults.standard.set(user.isAnonymous, forKey:"isAnonymous")

            guard let startTime = self.startTime else { return }

            Analytics.logEvent("AnonymousUserSignUp", parameters: [
                "timePassed": currentTime - startTime as NSObject
                ])
            Analytics.logEvent("AnonymousUser", parameters: ["count": 1 as NSObject])

            print("appdelegate.switchToPlayNavigationController was triggered.")
            
            //swiftlint:disable force_cast
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.switchToPlayNavigationController()
            //swiftlint:enable
            
//            gotoProfilePage(from: self)

        }

    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.isNavigationBarHidden = true

        titleLabel.text = NSLocalizedString("King of Song Quiz", comment: "Title label text at landing page.")
        loginLabel.text = NSLocalizedString("Sign In", comment: "SignIn label text at landing page.")
        signupLabel.text = NSLocalizedString("Sign Up", comment: "Signup label text at landing page.")
        anonymousLoginTextLabel.text = NSLocalizedString("Log in Anonymously ", comment: "For anonymous login.")

        createTitleLabelShadow(target: titleLabel)

        setCornerRadiustTo(loginLabel)
        loginLabel.layer.borderColor = UIColor.white.cgColor
        loginLabel.layer.borderWidth = 2
        loginLabel.backgroundColor = UIColor.clear

        setCornerRadiustTo(signupLabel)

        setCornerRadiustTo(anonymousLoginLabel)

        loginButtonOutlet.setTitleColor(UIColor.clear, for: .normal)

        signUpButtonOutlet.setTitleColor(UIColor.clear, for: .normal)

        anonymousLoginButtonOutlet.setTitleColor(UIColor.clear, for: .normal)

        self.ref = Database.database().reference()

        let userRef = self.ref.child("anonymousUsers/defaultSetting")

        userRef.observeSingleEvent(of: .value, with: { (snapshot) in

            let json = JSON(snapshot.value as Any)

            self.seedNumber = json["seedNumber"].intValue

            self.addNumber = json["signedUserCount"].intValue

        })

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.navigationController?.isNavigationBarHidden = true

        self.startTime = Date().timeIntervalSince1970
    }

    override func viewDidLayoutSubviews() {
        createGradientOnLabel(target: anonymousLoginLabel)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
