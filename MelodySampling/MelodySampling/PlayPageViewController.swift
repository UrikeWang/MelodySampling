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
    
    var correctAnswer = ""

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

        tableView.reloadData()

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

            self.questionList = self.fakeArtistList

            self.questionList.append(self.artistList[self.prepareTrack])

            self.shuffledList = self.questionList.shuffled()

            self.tableView.reloadData()

            let fileName = self.path + self.songFileNameList[self.prepareTrack]

            do {

                self.player = try AVAudioPlayer(contentsOf: URL(string: fileName)!)

            } catch {
                self.player = nil
            }

            self.player?.play()
            
            self.correctAnswer = self.artistList[self.prepareTrack]

            self.prepareTrack += 1

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

        let selectedSection = indexPath.section

        print("你選了第 \(selectedSection) 個選項")

        //先做答對與答錯的功能
        
        
        if artistList.count == 5 {
            
            //做答對答錯判斷
//            if shuffledList[indexPath.section] == correctAnswer {
//                print("你答對了")
//            } else {
//                print("你答錯了，答案是 \(correctAnswer)")
//            }
//
            switch prepareTrack {

            case 5:

                player?.pause()

                player = nil

                performSegue(withIdentifier: "goToResult", sender: self)

            default:

                questionList = fakeArtistList

                questionList.append(artistList[prepareTrack])

                shuffledList = questionList.shuffled()

                correctAnswer = artistList[prepareTrack]
                
                if shuffledList[indexPath.section] == correctAnswer {
                    print("你答對了")
                    
                    resultList.append(true)
                    
                } else {
                    print("你答錯了 正確選項是 \(correctAnswer)")
                    resultList.append(false)
                }
                    
                
                
                tableView.reloadData()

                let fileName = self.path + songFileNameList[prepareTrack]

                player?.pause()

                do {

                    player = try AVAudioPlayer(contentsOf: URL(string: fileName)!)

                } catch {
                    player = nil
                }

                player?.play()

                prepareTrack += 1
            }
        }

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
