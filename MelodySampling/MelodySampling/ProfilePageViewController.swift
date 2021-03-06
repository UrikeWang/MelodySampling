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

class ProfilePageViewController: UIViewController, NSFetchedResultsControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var imageCache = NSCache<NSString, UIImage>()

    @IBOutlet weak var historyTableView: UITableView! {
        didSet {
            historyTableView.backgroundColor = UIColor.mldUltramarine
        }
    }

    
    @IBOutlet weak var profileContentView: UIView!
    @IBOutlet weak var userProfileImageView: UIImageView!
    @IBOutlet var versionLabel: UILabel!
    @IBOutlet weak var playContentView: UIView!
    @IBOutlet weak var playTextLabel: UILabel!
    @IBOutlet weak var logOutView: UIView!
    @IBOutlet weak var logOutButtonOutlet: UIButton!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var invisiblePhotoUsageButtonOutlet: UIButton!
    @IBOutlet weak var historyLabel: UILabel!
    @IBOutlet weak var emptyLabel: UILabel!
    @IBOutlet weak var invisibleUserNameButtonOutlet: UIButton!
    @IBOutlet weak var invisiblePlayButton: UIButton!
    var unixTimestamp: Double?
    var userMarqueeView = MarqueeView()
    
    var fetchResultController: NSFetchedResultsController<HistoryMO>!
    var historyList: [HistoryMO] = []
    var distracorList = [String]()
    let userDefault = UserDefaults.standard
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        historyLabel.text = NSLocalizedString("History", comment: "History segament controller label")
        
        logOutButtonOutlet.setTitle(NSLocalizedString("Sign out", comment: "Log out text at profile page."), for: .normal)
        
        playTextLabel.text = NSLocalizedString("Play", comment: "Play button text at profile page.")
        
        invisibleUserNameButtonOutlet.setTitleColor(UIColor.clear, for: .normal)
        
        print("===== Profile Page =====")
        
        invisiblePhotoUsageButtonOutlet.setTitleColor(UIColor.clear, for: .normal)
        
        logOutButtonOutlet.setTitleColor(UIColor.white, for: .normal)
        
        invisiblePlayButton.setTitleColor(UIColor.clear, for: .normal)
        
        historyTableView.delegate = self
        
        historyTableView.dataSource = self
        
        createUserProfileImage(targe: userProfileImageView)
        
        if let userProfileImageData = userDefault.object(forKey: "UserProfileImage") as? Data {
            
            userProfileImageView.image = UIImage(data: userProfileImageData)
            
        }
        
        if let userName = userDefault.object(forKey: "userName") as? String {
            self.userMarqueeView = MarqueeView(frame: userNameLabel.frame, title: userName)
        } else {
            self.userMarqueeView = MarqueeView(frame: userNameLabel.frame, title: "Player")
        }
        
        profileContentView.insertSubview(self.userMarqueeView, at: 1)
        userNameLabel.isHidden = true
        
        if let currentVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            versionLabel.text = "V\(currentVersion)"
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        emptyLabel.isHidden = true
        
        let radius = self.userProfileImageView.frame.width
        
        userProfileImageView.layer.cornerRadius = radius / 2
        
        logOutButtonOutlet.layer.borderColor = UIColor.white.cgColor
        logOutButtonOutlet.layer.borderWidth = 2
        logOutButtonOutlet.layer.cornerRadius = 30.0
        
        //createNextBattleOfResult(target: playButtonLabel)
        
        playContentView.layer.cornerRadius = 30.0
        
        // ====== fetch history CoreData here =====
        
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
        
        if historyList.count == 0 {
            
            emptyLabel.isHidden = false
            
            emptyLabel.text = NSLocalizedString("Please Tap Play Button", comment: "No battle record yet")
            emptyLabel.textColor = UIColor.white
            emptyLabel.font = UIFont.mldTextStyleEmptyFont()!
            emptyLabel.textAlignment = .center
            emptyLabel.numberOfLines = 0
            
        }
        
        self.ref = Database.database().reference()
        let timePathPush = ref.child("currentTime")
        let timeDict = ["timestamp": ServerValue.timestamp()] as [String: Any]
        timePathPush.updateChildValues(timeDict)
        
        let timePathGet = ref.child("currentTime")
        
        timePathGet.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let value = snapshot.value as? [String: Any],
                let timestamp = value["timestamp"] as? Double else { return }
            
            self.unixTimestamp = timestamp / 1000
            let date = Date(timeIntervalSince1970: self.unixTimestamp!)
            let strDate = DateUtility.getStrDate(from: date)
            let weekOfYear = DateUtility.getWeekOfYear(from: date)
            
            print("目前聽到的時間: \(timestamp)")
            print("轉換後的時間: \(strDate)")
            print("週數: \(weekOfYear)")
        }) { (err) in
            print("error :\(err)")
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        userMarqueeView.frame = userNameLabel.frame
    }
    
    // MARK: - IBAction
    
    @IBAction func invisibleUserNameButtonTapped(_ sender: UIButton) {

        let alertController = UIAlertController(title: NSLocalizedString("Rename", comment: "Tapping for rename action"), message: "", preferredStyle: .alert)

        let saveAction = UIAlertAction(title: NSLocalizedString("Confirm", comment: "Confirm input for rename action"), style: .default) { (_) in

            let renameTextField = alertController.textFields![0] as UITextField

            self.userMarqueeView.removeFromSuperview()
            
            let newUserMarqueeView = MarqueeView(frame: self.userNameLabel.frame, title: renameTextField.text!)
            
            self.profileContentView.insertSubview(newUserMarqueeView, at: 1)
            
            self.userMarqueeView = newUserMarqueeView

            self.userNameLabel.isHidden = true

            self.userDefault.set(renameTextField.text, forKey: "userName")

            let updateManager = UpdateManager()

            if let uid = self.userDefault.object(forKey: "uid") as? String {

                // TODO: Revise unwrap later.
                updateManager.updateUserName(uid, update: renameTextField.text!)

                print("Uid is \(uid),Username is \(renameTextField)")
            }

        }

        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel for rename action"), style: .default) { (_) in
        }

        alertController.addTextField { (textField: UITextField!) -> Void in
            textField.placeholder = "Input username you like."
        }

        alertController.addAction(cancelAction)
        alertController.addAction(saveAction)
        self.present(alertController, animated: true, completion: nil)

    }

    @IBAction func invisiblePhotoUsageButtonTapped(_ sender: UIButton) {

        let imagePicker = UIImagePickerController()

        imagePicker.delegate = self

        imagePicker.sourceType = UIImagePickerControllerSourceType.savedPhotosAlbum

        present(imagePicker, animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {

        let image = info[UIImagePickerControllerOriginalImage] as? UIImage

        self.userProfileImageView.image = image

        let imageData = UIImagePNGRepresentation(image!)

        userDefault.set(imageData, forKey: "UserProfileImage")

        dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {

        dismiss(animated: true, completion: nil)
    }

    @IBAction func logOutButtonTapped(_ sender: UIButton) {

        let alertController = UIAlertController(title: NSLocalizedString("Sign Out", comment: "Sign out button on profile page"), message: NSLocalizedString("Are you going to sign out?", comment: "Sign Out Message on profile page"), preferredStyle: .alert)

        let logoutAction = UIAlertAction(title: NSLocalizedString("Sign Out", comment: "Sign out from profile page"), style: .destructive) { (_) in

            let userDefault = UserDefaults.standard

            let keysInArray = Array(userDefault.dictionaryRepresentation().keys)

            for each in keysInArray {
                userDefault.removeObject(forKey: "\(each)")
            }

            let checkCoredata = CheckQuestionInCoreData()

            checkCoredata.clearHistoryMO()

            //swiftlint:disable force_cast
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.switchToLandingNavigationController()
            //swiftlint:enable
        }

        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel on sign out action"), style: .default) { (_) in

        }

        alertController.addAction(cancelAction)

        alertController.addAction(logoutAction)

        self.present(alertController, animated: true, completion: nil)

        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }

    }

}

extension ProfilePageViewController: UITableViewDelegate, UITableViewDataSource {

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

    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {

        if let customCell = cell as? HistoryTableViewCell {

            customCell.artworkImageView.image = nil
        }

    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cellIdentifier = "HistoryCell"

        //swiftlint:disable force_cast
        let cell = historyTableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! HistoryTableViewCell
        //swiftlint:enable

        cell.artistNameLabel.text = historyList[indexPath.row].artistName
        cell.trackNameLabel.text = historyList[indexPath.row].trackName

        if let url = historyList[indexPath.row].artworkUrl as NSString?, let imageFromCache = imageCache.object(forKey: url) {

            cell.artworkImageView.image = imageFromCache
        } else {

            DispatchQueue.global().async {

                guard
                    let artworkUrl = self.historyList[indexPath.row].artworkUrl,
                    let url = URL(string: artworkUrl)
                    else {
                        return
                }

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

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch UIScreen.main.bounds.height {
        case let x where x > 800:
            return 100
        default:
            return 60
        }
    }

}
