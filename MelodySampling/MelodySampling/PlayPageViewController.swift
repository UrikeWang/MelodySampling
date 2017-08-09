//
//  PlayPageViewController.swift
//  MelodySampling
//
//  Created by moon on 2017/8/8.
//  Copyright © 2017年 Marvin Lin. All rights reserved.
//

import UIKit
import AVFoundation
import Firebase

class PlayPageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var ref: DatabaseReference!

    var player: AVAudioPlayer?

    let path: String = NSHomeDirectory() + "/Documents/"

    var fakeArtistList = ["Fake 1", "Fake 2", "Fake 3"]

    var questionList = [String]()

    var currentTrack: Int = 0

    var prepareTrack: Int = 0

    let songFileNameList = ["song0.m4a", "song1.m4a", "song2.m4a", "song3.m4a", "song4.m4a"]

    var shuffledList = [String]()

    var artistList = [String]()

    var resultList = [Bool]()

    @IBOutlet weak var tableView: UITableView!

    @IBAction func checkButtonTapped(_ sender: UIButton) {

        print(resultList)

    }

    @IBAction func playButtonTapped(_ sender: UIButton) {
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self

        tableView.dataSource = self

        self.ref = Database.database().reference()

        ref.child("questionBanks").child("mandarin").child("genreCod1").child("question1").queryOrderedByKey().observeSingleEvent(of: .value, with: { (snapshot) in

            let postDict = snapshot.value as? [String: AnyObject] ?? [:]

            for eachTrackID in postDict {

                let temp = eachTrackID.value as? [String: AnyObject]
//                print(temp)

                guard let artist = temp?["artistName"] else { return }

                self.artistList.append((artist as? String)!)

            }

            print("Artlist downloading done")
            
            self.startGuessing()
            

        })
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return (shuffledList.count)
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cellIdentifier = "Cell"

        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as UITableViewCell

        cell.textLabel?.text = shuffledList[indexPath.section]

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let selectedAnswer = shuffledList[indexPath.section]

        let answer = artistList[currentTrack]

        print("你選了 \(selectedAnswer) 個選項")

        if judgeAnswer(input: selectedAnswer, compare: answer) {

            resultList.append(true)
            print("答對了")
        } else {

            resultList.append(false)
            print("答錯了，正解是 \(answer)")
        }

        if prepareTrack == 5 {

            player?.pause()

            player = nil

            performSegue(withIdentifier: "goToResult", sender: self)

        } else {

            questionList = fakeArtistList

            questionList.append(artistList[prepareTrack])

            shuffledList = questionList.shuffled()

            tableView.reloadData()

            player?.pause()

            let fileName = self.path + songFileNameList[prepareTrack]

            do {

                player = try AVAudioPlayer(contentsOf: URL(string: fileName)!)

            } catch {
                player = nil
            }

            player?.play()

            currentTrack = prepareTrack

            prepareTrack += 1

        }

    }

    func startGuessing() {
        //進行第0首歌的猜謎
        self.questionList = self.fakeArtistList
        
        self.questionList.append(self.artistList[self.currentTrack])
        
        self.shuffledList = self.questionList.shuffled()
        
        self.tableView.reloadData()
        
        let fileName = self.path + self.songFileNameList[self.currentTrack]
        
        do {
            
            self.player = try AVAudioPlayer(contentsOf: URL(string: fileName)!)
            
        } catch {
            self.player = nil
        }
        
        self.player?.play()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
