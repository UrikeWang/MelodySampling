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

    @IBOutlet weak var label4: UILabel!

    @IBOutlet weak var label5: UILabel!

    @IBOutlet weak var currentScoreLabel: UILabel!

    var timeStart: Double?

    var timeEnd: Double?

    var timePassed: Double?

    var songTrackFlag: Int = 0

    var score = 0

    @IBAction func leftButtonTapped(_ sender: UIButton) {

        timeStart = Date().timeIntervalSince1970

        label1.text = "\(timeStart)"
    }

    @IBAction func rightBUttonTapped(_ sender: UIButton) {

        timeEnd = Date().timeIntervalSince1970

        label2.text = "\(timeEnd)"

        timePassed = timeEnd! - timeStart!

        label3.text = "\(timePassed)"

        songTrackFlag += 1

        label4.text = "你現在正在玩\(songTrackFlag)"

        let currentScore = scoreAfterOneSong(time: timePassed!)

        currentScoreLabel.text = "當次得分為 \(currentScore)"

        score += currentScore

        label5.text = "累積得分: \(score)"

    }

    override func viewDidLoad() {
        super.viewDidLoad()

        label4.text = "按下左邊的鍵，開始遊戲"

        label5.text = "你的得分是 \(score)"

        currentScoreLabel.text = "還沒開始"

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
