//
//  TimerViewController.swift
//  MelodySampling
//
//  Created by moon on 2017/8/8.
//  Copyright © 2017年 Marvin Lin. All rights reserved.
//

import UIKit

class TimerViewController: UIViewController {

    @IBOutlet weak var label1: UILabel!

    @IBOutlet weak var label2: UILabel!

    @IBOutlet weak var label3: UILabel!

    var timeStart: Double?

    var timeEnd: Double?

    var timePassed: Double?

    @IBAction func leftButtonTapped(_ sender: UIButton) {

        timeStart = Date().timeIntervalSince1970

        label1.text = "\(timeStart)"
    }

    @IBAction func rightBUttonTapped(_ sender: UIButton) {

        timeEnd = Date().timeIntervalSince1970

        label2.text = "\(timeEnd)"

        timePassed = timeEnd! - timeStart!

        label3.text = "\(timePassed)"

    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
