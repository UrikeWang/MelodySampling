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
    
    func play(songString: String) {
        
        do {
            
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            
            print("播放歌曲url \(songString)")
            
            player = AVPlayer(url: URL(string: songString)!)
            
            print("即將播放....")
            player?.play()
            print("播放中....")
            
        } catch {
            
            player = nil
            
            print("音樂播放發生錯誤")
            
        }
        
    }
    
    func stopAVPLayer() {
        
//        var player: AVPlayer?
        
        player?.pause()

//        if player?.isPlaying == true {
//            player?.stop()
        }

    }
//
//    func toggleAVPlayer() {
//
//        if player?.isPlaying == true {
//            player?.pause()
//
//        } else {
//            player?.play()
//        }
//    }
    


//extension Player: AVAudioPlayerDelegate {
//
//    func audioPlayerDidFinishPlaying(player: AVAudioPlayer!, successfully flag: Bool) {
//        print("finished playing \(flag)")
//    }
//
//
//    func audioPlayerDecodeErrorDidOccur(player: AVAudioPlayer!, error: NSError!) {
//        print("\(error.localizedDescription)")
//    }
//
//}

