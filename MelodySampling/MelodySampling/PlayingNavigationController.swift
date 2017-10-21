//
//  PlayingNavigationController.swift
//  King of Song Quiz
//
//  Created by moon on 2017/10/19.
//  Copyright © 2017年 Marvin Lin. All rights reserved.
//

import UIKit

class PlayingNavigationController: UINavigationController {

    var questionArray = [EachQuestion]()
    
    var resultArray = [ResultToShow]()
    
    var distractorArray = [String]()
    
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
