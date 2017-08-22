//
//  ProfilePageViewController.swift
//  MelodySampling
//
//  Created by moon on 2017/8/11.
//  Copyright © 2017年 Marvin Lin. All rights reserved.
//

import UIKit
import Firebase
import CoreData

class ProfilePageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var imageCache = NSCache<NSString, UIImage>()

    @IBOutlet weak var historyTableView: UITableView! {
        didSet {
            historyTableView.backgroundColor = UIColor.mldUltramarine
        }
    }

    @IBOutlet weak var userProfileImageView: UIImageView!

    var fetchResultController: NSFetchedResultsController<HistoryMO>!

    var historyList: [HistoryMO] = []

    var distracorList = [String]()

    let userDefault = UserDefaults.standard

    @IBOutlet weak var playButtonLabel: UILabel!

    @IBOutlet weak var playTextLabel: UILabel!

    @IBOutlet weak var invisibleButton: UIButton!

    @IBOutlet weak var logOutView: UIView!

    @IBOutlet weak var logOutContentView: UIView!

    @IBOutlet weak var logOutButtonOutlet: UIButton!

    @IBOutlet weak var userNameLabel: UILabel!

    @IBOutlet weak var invisiblePhotoUsageButtonOutlet: UIButton!

    @IBAction func invisiblePhotoUsageButtonTapped(_ sender: UIButton) {

        let imagePicker = UIImagePickerController()

        imagePicker.delegate = self

        imagePicker.sourceType = UIImagePickerControllerSourceType.savedPhotosAlbum

        present(imagePicker, animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        print("使用者選完照片了")

        let image = info[UIImagePickerControllerOriginalImage] as? UIImage

        self.userProfileImageView.image = image

        let imageData = UIImagePNGRepresentation(image!)

        userDefault.set(imageData, forKey: "UserProfileImage")

        dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("使用者取消選取")

        dismiss(animated: true, completion: nil)
    }

    @IBAction func logOutButtonTapped(_ sender: UIButton) {

        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }

        let userDefault = UserDefaults.standard

        let keysInArray = Array(userDefault.dictionaryRepresentation().keys)

        for each in keysInArray {
            userDefault.removeObject(forKey: "\(each)")
        }

        let checkCoredata = CheckQuestionInCoreData()

        checkCoredata.clearHistoryMO()

        gotoLandingPage(from: self)

    }

    @IBAction func invisibleButtonTapped(_ sender: UIButton) {
        print("Play button tapped")

        gotoTypeChoosePage(from: self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        print("===== Profile Page =====")
        
        invisiblePhotoUsageButtonOutlet.setTitleColor(UIColor.clear, for: .normal)

        logOutButtonOutlet.setTitleColor(UIColor.clear, for: .normal)

        invisibleButton.setTitleColor(UIColor.clear, for: .normal)

        historyTableView.delegate = self

        historyTableView.dataSource = self

        createUserProfileImage(targe: userProfileImageView)

        logOutContentView.backgroundColor = UIColor.clear

        if let userProfileImageData = userDefault.object(forKey: "UserProfileImage") as? Data {

            userProfileImageView.image = UIImage(data: userProfileImageData)

        }

        if let userName = userDefault.object(forKey: "userName") as? String {
            userNameLabel.text = userName
        } else {
            userNameLabel.text = "This is you"
        }

        let fetchRequest: NSFetchRequest<HistoryMO> = HistoryMO.fetchRequest()

        let sortDescriptor = NSSortDescriptor(key: "timeIndex", ascending: false)

        fetchRequest.sortDescriptors = [sortDescriptor]

        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {

            let context = appDelegate.persistentContainer.viewContext

            fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)

            fetchResultController.delegate = self

            do {

                try fetchResultController.performFetch()

                if let fetchedObjects = fetchResultController.fetchedObjects {

                    historyList = fetchedObjects

                    historyTableView.reloadData()

                }

            } catch {
                historyList = []
                print(error)
            }

        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return historyList.count
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {

        gradientLayer = CAGradientLayer()

        gradientLayer.frame = cell.bounds

        gradientLayer.colors = [UIColor.mldUltramarineBlueTwo.cgColor, UIColor.mldUltramarine.cgColor]

        cell.layer.insertSublayer(gradientLayer, at: 0)
        cell.backgroundColor = UIColor.clear

    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cellIdentifier = "HistoryCell"

        //swiftlint:disable force_cast
        let cell = historyTableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! HistoryTableViewCell
        //swiftlint:enable

        cell.artistNameLabel.text = historyList[indexPath.row].artistName
        cell.trackNameLabel.text = historyList[indexPath.row].trackName

        if let imageFromCache = imageCache.object(forKey: historyList[indexPath.row].artworkUrl! as NSString) {

            cell.artworkImageView.image = imageFromCache

        } else {

            DispatchQueue.global().async {

                guard let artworkUrl = self.historyList[indexPath.row].artworkUrl, let url = URL(string: artworkUrl) else { return }

                if let data = try? Data(contentsOf: url) {

                    DispatchQueue.main.async {

                        guard let imageToCache = UIImage(data: data) else {return}

                        self.imageCache.setObject(imageToCache, forKey: artworkUrl as NSString)

                        cell.artworkImageView.image = imageToCache
                    }
                }
            }
        }
        return cell
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let radius = self.userProfileImageView.frame.width
        
        userProfileImageView.layer.cornerRadius = radius / 2
        
        createUserProfilePageLogoutBackground(target: logOutView)
        
        createNextBattleOfResult(target: playButtonLabel)
        
        if historyList.count == 0 {
            
            let framOfTableView = self.historyTableView.frame
            
            let emptyView = UIView(frame: framOfTableView)
            
            let emptyLabel = createLabel(at: emptyView, content: "尚無對戰紀錄", color: UIColor.white, font: UIFont.mldTextStyleEmptyFont()!)
            
            createProfilePageHistoryCellBackground(target: emptyView)
            
            self.view.addSubview(emptyView)
            
            self.view.addSubview(emptyLabel)
            
        }

    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }

}
