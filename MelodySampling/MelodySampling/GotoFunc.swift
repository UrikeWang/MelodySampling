//
//  GotoFunc.swift
//  MelodySampling
//
//  Created by moon on 2017/8/15.
//  Copyright © 2017年 Marvin Lin. All rights reserved.
//

import Foundation
import UIKit

func gotoTypeChoosePage(from viewController: UIViewController) {

    let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)

    let registerVC = storyBoard.instantiateViewController(withIdentifier: "NewTypeChoosePage")

    viewController.present(registerVC, animated: true, completion: nil)
}

func gotoProfilePage(from viewController: UIViewController) {

    let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)

    let registerVC = storyBoard.instantiateViewController(withIdentifier: "ProfilePage")

    viewController.present(registerVC, animated: true, completion: nil)
}

func gotoLoginPage(from viewController: UIViewController) {

    let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)

    let registerVC = storyBoard.instantiateViewController(withIdentifier: "LoginPage")

    viewController.present(registerVC, animated: true, completion: nil)
}

func gotoSignupPage(from viewController: UIViewController) {

    let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)

    let registerVC = storyBoard.instantiateViewController(withIdentifier: "SignupPage")

    viewController.present(registerVC, animated: true, completion: nil)
}
