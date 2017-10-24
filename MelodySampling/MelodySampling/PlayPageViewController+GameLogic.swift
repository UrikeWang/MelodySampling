//
//  PlayPageViewController+GameLogic.swift
//  King of Song Quiz
//
//  Created by moon on 2017/9/28.
//  Copyright © 2017年 Marvin Lin. All rights reserved.
//

import Foundation
import AVFoundation
import FirebaseAnalytics

extension PlayPageViewController {
    
    func updateTimer() {
        
        // MARK: Need to deinit this func
        if trackTimeCountdown < 1 {
            print("timer 停了")
            
            timer.invalidate()
            
            trackTimeCountdownLabel.text = "\(0)"
            
        } else {
            self.trackTimeCountdown -= 1
            
            trackTimeCountdownLabel.text = "\(self.trackTimeCountdown)"
        }
    }
    
    func runTime() {
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(self.updateTimer)), userInfo: nil, repeats: true)
        
    }
    
    func countingTrigger() {
        
        countDownLabel.isHidden = true
        coverView.isHidden = true
        
        self.timeStart = Date().timeIntervalSince1970
        
        totalTimeStart = self.timeStart
        
        self.runTime()
        
        self.startGuessing()
    }
    
    func startGuessing() {
        
        print("現在在第 \(currentTrack) 首")
        
        self.shuffledList = []
        
        for index in 0..<3 {
            print(index)
            let distractorItem = distractors[index]
            
            let distractor = distractorItem
            
            if self.questionList.contains(distractor) == false {
                self.questionList.append(distractor)
            }
        }
        
        for eachDistractor in self.questionList {
            Analytics.logEvent("distractors", parameters: ["distractor": eachDistractor as NSObject])
        }
        
        // MARK: Revised questionList to navigationQuestionList
        //        self.questionList.append(self.trackNameArray[self.currentTrack])
        
        let currentQuestion = self.navigationQuestionArray[self.currentTrack]
        
        self.questionList.append(currentQuestion.trackName)
        
        self.shuffledList = self.questionList.shuffled()
        
        self.tableView.reloadData()
        
        let fileName = self.path + self.songFileNameList[self.currentTrack]
        
        do {
            
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            
            self.player = try AVAudioPlayer(contentsOf: URL(string: fileName)!)
            
        } catch {
            self.player = nil
        }
        
        self.player?.play()
    }
    
}

