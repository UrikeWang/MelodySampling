//
//  Player.swift
//  King of Song Quiz
//
//  Created by yuling on 2018/3/15.
//  Copyright © 2018年 Marvin Lin. All rights reserved.
//

import Foundation
import AVFoundation


class Player: NSObject {
    
    var error: NSError?
    var player: AVPlayer?
    
    func play(songUrl: URL) {
        
        do {
            
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            
            player = AVPlayer(url: songUrl)
            
            player?.play()
            
        } catch {
            
            player = nil
            
            print("音樂播放發生錯誤")
            
        }
        
    }
    
    func stopAVPlayer() {
        
        player?.pause()

        }

    }
