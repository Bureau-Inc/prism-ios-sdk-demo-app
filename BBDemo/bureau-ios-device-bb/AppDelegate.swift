//
//  AppDelegate.swift
//  bureau-ios-device-bb
//
//  Created by User on 30/10/23.
//

import UIKit
import IQKeyboardManagerSwift
import prism_ios_fingerprint_sdk

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var sessionID:String?
    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        IQKeyboardManager.shared.enable = true
        sessionID = "Demo-"+NSUUID().uuidString
        BureauAPI.shared.configure(clientID: "1b87dd79-8504-425c-90c3-56f4cad27b0f", environment: .sandbox, sessionID: sessionID ?? "", enableBehavioralBiometrics: true)
        BureauAPI.shared.setUserID("Bureau-user")
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

