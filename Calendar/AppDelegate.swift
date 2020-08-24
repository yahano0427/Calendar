
//  AppDelegate.swift
//  Calendar
//
//  Created by 矢羽野裕介 on 2020/08/05.
//  Copyright © 2020 矢羽野. All rights reserved.
//

import UIKit
import Firebase
import SlideMenuControllerSwift
import GoogleMobileAds

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        //Firebase接続設定
        //クラウド上のデータベースのリンク:https://console.firebase.google.com/project/calendar-project-9bf20/database/firestore/data~2Fusers~2FuyQSGR7Yfq1EeHuqs7t9
        FirebaseApp.configure()
        
        //Google AdMob初期設定
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        
        //SlideMenuControllerSwiftの初期設定
        let slideMenuController = SlideMenuController(mainViewController: ViewController(), leftMenuViewController: LeftViewController())
        self.window?.rootViewController = slideMenuController
        self.window?.makeKeyAndVisible()
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
