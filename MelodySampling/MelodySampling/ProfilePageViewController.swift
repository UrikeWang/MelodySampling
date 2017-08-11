//
//  ProfilePageViewController.swift
//  MelodySampling
//
//  Created by moon on 2017/8/11.
//  Copyright © 2017年 Marvin Lin. All rights reserved.
//

import UIKit

class ProfilePageViewController: UIViewController {
    
    @IBAction func playButtonTapped(_ sender: Any) {
        print("This button tapped")
        
//        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        //swiftlint:disable force_cast
//        let registerVC = self.storyboard?.instantiateViewController(withIdentifier: "TypeChoose")
//        
//        self.present(registerVC!, animated: true, completion: nil)
        //swiftlint:enable
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
