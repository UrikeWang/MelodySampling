//
//  AnonymousLoginSuccedViewController.swift
//  MelodySampling
//
//  Created by moon on 2017/7/31.
//  Copyright © 2017年 Marvin Lin. All rights reserved.
//

import UIKit
import Firebase

class AnonymousLoginSuccedViewController: UIViewController {

    @IBOutlet weak var resultLabel: UILabel!

    @IBOutlet weak var emailTextField: UITextField!

    @IBOutlet weak var passwordTextField: UITextField!

    var ref: DatabaseReference!

    let userAccount = ""

    let userFullName = "Test User"

    let profileImageURL = ""

    @IBAction func signUpTapped(_ sender: UIButton) {

        guard let email = emailTextField.text, let password = passwordTextField.text, let user = Auth.auth().currentUser else {
            let text = "E-mail 或密碼輸入錯誤"
            print(text)
            resultLabel.text = text
            return
        }

        let credential = EmailAuthProvider.credential(withEmail: email, password: password)

        user.link(with: credential) { (user, _) in
            guard let user = user else {
                print("Register got error")
                return
            }

            print("Welcome to MelodySampling")
            print(user.uid)
            self.resultLabel.text = "Convert to pernament user \(user.uid) is your new ID"

            self.ref = Database.database().reference()

            let userRef = self.ref.child("users/\(user.uid)")

            let currentTime = Date().timeIntervalSince1970

            userRef.setValue(["fullName": self.userFullName, "createdTime": currentTime, "userAccount": self.userAccount, "profilePicURL": self.profileImageURL, "wasAnonymouse": true])
            
            let anonymousRef = self.ref.child("anonymousUsers/\(user.uid)")
            
            anonymousRef.updateChildValues(["isAnonymous": false])
            

        }

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //不知道為什麼，當判斷使用者是不是 anonymous 放在 ViewDidLoad 就是不會直接觸發

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if let user = Auth.auth().currentUser {

            if user.isAnonymous {
                print("使用者用暱名登入")
                resultLabel.text = "使用者用暱名登入"
            }
        }
    }
}
