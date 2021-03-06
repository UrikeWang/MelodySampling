//
//  AppDelegate.swift
//  MelodySampling
//
//  Created by moon on 2017/7/31.
//  Copyright © 2017年 Marvin Lin. All rights reserved.
//

import UIKit
import Firebase
import IQKeyboardManagerSwift
import CoreData
import Fabric
import Crashlytics
import UserNotifications
import FirebaseInstanceID
import FirebaseMessaging

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {

    var window: UIWindow?
    
    var ref: DatabaseReference!
    
    let userDefault = UserDefaults.standard

    var questionCounter: Int?

    enum TypeList: String {
        case mandarinPop, taiwanesePop, cantoPop, billboardPop
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: { granted , _ in

                    if granted {

                        Analytics.setUserProperty("UserNotificationGranted", forName: "UserNotification")

                    }
                    else {

                        Analytics.setUserProperty("UserNotificationDenied", forName: "UserNotification")

                    }

            })
            // For iOS 10 data message (sent via FCM
            Messaging.messaging().delegate = self
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)

        }
        application.registerForRemoteNotifications()
        FirebaseApp.configure()

        let _ = RemoteConfigValues.sharedInstance

        Fabric.with([Crashlytics.self])

        IQKeyboardManager.sharedManager().enable = true
        
        ref = Database.database().reference()
        
        ref.child("counter").observeSingleEvent(of: .value, with: { (snapshot) in
            
            guard let counterDictionary = snapshot.value as? [String: Int] else {
                print("Something wrong in cast snapshot")
                return
                
            }
            
            var counterArray = [Int]()
            
            for each in counterDictionary {
                counterArray.append(each.value)
            }
            
            var trackCounter: Int
            
            if let unwrapCounterArray = counterArray.min() {
                
                trackCounter = unwrapCounterArray
                
            } else {
                trackCounter = 1200
            }
            
            self.userDefault.set(trackCounter, forKey: "trackCounter")
            
            print("CounterMin: \(trackCounter)")
            
            
        })


//        let downloadManager = DownloadManager()
//
//        downloadManager.getCounter()
        
        self.window = UIWindow(frame: UIScreen.main.bounds)

        let storyboard = UIStoryboard(name: "Main", bundle: nil)

        if userDefault.value(forKey: "uid") != nil {

            let registerVC = storyboard.instantiateViewController(withIdentifier: "PlayingNavigation")

            self.window?.rootViewController = registerVC

        } else {

            let registerVC = storyboard.instantiateViewController(withIdentifier: "LandingNavigation")

            self.window?.rootViewController = registerVC
        }

        return true
    }
    
    func switchToPlayNavigationController() {
        
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let navigationController = storyboard.instantiateViewController(withIdentifier: "PlayingNavigation")
        self.window?.rootViewController = navigationController
    }
    
    func switchToLandingNavigationController() {
        
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let navigationController = storyboard.instantiateViewController(withIdentifier: "LandingNavigation")
        self.window?.rootViewController = navigationController
    }

    // The callback to handle data message received via FCM for devices running iOS 10 or above.
    func application(received remoteMessage: MessagingRemoteMessage) {
//        print(remoteMessage.appData)
    }

    func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {
//        print(messaging)
//        let token = Messaging.messaging().fcmToken
//        print("FCM token: \(token ?? "")")
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "MelodySampling")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful durinconnectopment.
                let nserror = error as NSError;             fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}
