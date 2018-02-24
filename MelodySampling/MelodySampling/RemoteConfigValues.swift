//
//  APPversionValue.swift
//  King of Song Quiz
//
//  Created by Meng Hsien Lin on 2018/1/23.
//  Copyright © 2018年 Marvin Lin. All rights reserved.
//

import UIKit
import Firebase
import FirebaseRemoteConfig

enum RemoteConfigValueKey: String {
    case appVersion
    case appStoreURL = "itms-apps://itunes.apple.com/tw/app/id1273605195"
}

class RemoteConfigValues {
    static let sharedInstance = RemoteConfigValues()

    private init() {
        loadDefaultValue()
        fetchCloudValues()
    }

    func loadDefaultValue() {
        guard let currentVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else {
            return
        }
        let appDefault: [String: NSObject] = [
            RemoteConfigValueKey.appVersion.rawValue: currentVersion as NSObject
        ]
        RemoteConfig.remoteConfig().setDefaults(appDefault)
    }

    func fetchCloudValues() {
        // 1
        // WARNING: Don't actually do this in production!
//        let fetchDuration: TimeInterval = 0
//        activateDebugMode()
            RemoteConfig.remoteConfig().fetch() {
            [weak self] (status, error) in

            guard error == nil else {
                print ("Got an error fetching remote values \(error)")
                return
            }

            // 2
            RemoteConfig.remoteConfig().activateFetched()
            print("Retrieved values from the cloud!")

                guard let storeVersion = RemoteConfig.remoteConfig().configValue(forKey: "APP_version").stringValue,
                    let currentVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String,
                    let url = URL(string: RemoteConfigValueKey.appStoreURL.rawValue),
                    let topController = UIApplication.shared.keyWindow?.rootViewController
                else {
                    return
                }
                if currentVersion.compare(storeVersion, options: .numeric) == .orderedAscending {
                    print("current Version: \(currentVersion)")
                    print("store Vsion: \(storeVersion)")
                    print("網路上版本比較新，發動更新")

                    let alertController = UIAlertController(title: NSLocalizedString("Update notice", comment: "Update notice"), message: NSLocalizedString("Press OK button to get neweset version.", comment: "Update message"), preferredStyle: .alert)

                    let okAction = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default) { (_) in
                        UIApplication.shared.open(url)
                    }

                    alertController.addAction(okAction)
                    topController.present(alertController, animated: true, completion: nil)

                } else {
                    print("已經是最新版，不用更新")
                }
        }
    }

    func activateDebugMode() {
        let debugSettings = RemoteConfigSettings(developerModeEnabled: true)
        RemoteConfig.remoteConfig().configSettings = debugSettings!
    }
}
