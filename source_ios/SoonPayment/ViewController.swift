//
//  ViewController.swift
//  SoonPayment
//
//  Created by Markus Bergh on 2017-11-18.
//  Copyright © 2017 Markus Bergh. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var contentView: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.clear
        
        contentView = UIView(frame: CGRect.zero)
    }
    
    func setDaysUntilPayday() {
        // Get days left
        let daysLeftUntilPayday = calculateDifferenceBetweenTodayAndPayDay()
        
        // Set content state depending on calculation
        isTodayEqualPayday(payIsDue: daysLeftUntilPayday == 0, daysLeftUntilPayday: daysLeftUntilPayday)
    }
    
    func calculateDifferenceBetweenTodayAndPayDay() -> Int {
        // Counter
        var daysLeftUntilPayday = 0;
        
        // Get today
        let today = Date()
        
        // Create calendar and set time zone
        let calendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)
        let timeZone: TimeZone = TimeZone(abbreviation: "CET")!
        calendar?.timeZone = timeZone
        
        // Get components
        let unitFlags: NSCalendar.Unit = [NSCalendar.Unit.year, NSCalendar.Unit.month, NSCalendar.Unit.weekday, NSCalendar.Unit.day]
        var components = calendar?.components(unitFlags, from: today)
        
        // Set date to 25th
        components?.setValue(25, for: Calendar.Component.day)
        
        // Get pay day
        var payday = calendar?.date(from: components!)
        let weekdayRange = calendar?.maximumRange(of: NSCalendar.Unit.weekday)
        let weekday = calendar?.components(NSCalendar.Unit.weekday, from: payday!).weekday
        
        // If payday is in week end (Saturday or Sunday), we set pay day to Friday before weekend
        if weekday == weekdayRange?.location || weekday == weekdayRange?.length {
            switch weekday! {
            case 7:
                payday = payday?.addingTimeInterval(60 * 60 * 24 * -1)
            case 1:
                payday = payday?.addingTimeInterval(60 * 60 * 24 * -2)
            default:
                break
            }
        }
        
        // Create and set date format
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss z"
        
        // Get days between
        daysLeftUntilPayday = daysBetweenDates(from: today, to: payday!)
        
        // Return result
        return daysLeftUntilPayday;
    }
    
    func daysBetweenDates(from: Date, to: Date) -> Int {
        let calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        
        return calendar.dateComponents([Calendar.Component.day], from: from, to: to).day!
    }
    
    func isTodayEqualPayday(payIsDue: Bool, daysLeftUntilPayday: Int) {
        // Create label
        let header = UILabel()
        header.textColor = UIColor.white
        header.font = header.font.withSize(25)
        
        if payIsDue {
            // Set text
            header.text = "Det är löning!"
            
            // Clear badge
            return UIApplication.shared.applicationIconBadgeNumber = 0
        }
        
        // Set label text
        let daysLeftToPaydayString = String(format: "%d", daysLeftUntilPayday)

        // Set text
        header.text = daysLeftToPaydayString + " dagar kvar till lön"
        
        // Size and position
        header.sizeToFit()
        header.center = self.view.center
        
        // Add label
        self.view.addSubview(header)
        
        // Set badge
        return UIApplication.shared.applicationIconBadgeNumber = daysLeftUntilPayday
    }
}
