//
//  LocalNotification.swift
//  SoonPayment
//
//  Created by Markus Bergh on 2017-11-18.
//  Copyright © 2017 Markus Bergh. All rights reserved.
//

import Foundation
import UserNotifications

class LocalNotification {
    class func setUpLocalNotification() {
        let calendar = NSCalendar(identifier: NSCalendar.Identifier.gregorian)
        var today = Date()
        today = today.addingTimeInterval(86400)
        
        let components = calendar?.components([.hour, .minute, .second], from: today)
        
        let content = UNMutableNotificationContent()
        content.badge = 5
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: components!, repeats: false)
        let request = UNNotificationRequest(identifier: "PaydayUpdate", content: content, trigger: trigger)
        
        let center = UNUserNotificationCenter.current()
        center.add(request) { (error : Error?) in
            if let theError = error {
                print(theError.localizedDescription)
            }
        }

    }
}
