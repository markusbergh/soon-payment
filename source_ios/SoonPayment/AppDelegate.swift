//
//  AppDelegate.swift
//  SoonPayment
//
//  Created by Markus Bergh on 2017-11-18.
//  Copyright © 2017 Markus Bergh. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    var window: UIWindow?
    var viewController: ViewController?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        // Override point for customization after application launch.
        
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [UNAuthorizationOptions.badge]) { (granted, error) in
            // Enable or disable features based on authorization.
            if granted {
                LocalNotification.setUpLocalNotification()
            }
        }
        
        let screenBounds: CGRect = UIScreen.main.bounds
        
        if (screenBounds.size.height == 568) {
            self.window?.backgroundColor = UIColor(patternImage: UIImage(named: "Background-1136.png")!)
        } else {
            self.window?.backgroundColor = UIColor(patternImage: UIImage(named: "Background.png")!)
        }
        
        viewController = ViewController()
        self.window?.addSubview(viewController!.view)
        
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        
        return true
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // Update the app interface directly.
        
    }
    
    

}
