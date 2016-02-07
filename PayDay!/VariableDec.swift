//
//  VariableDec.swift
//  PayDay!
//
//  Created by Brian van den Heuvel on 9/22/15.
//  Copyright © 2015 Brian van den Heuvel. All rights reserved.
//

import Foundation

class VariableDec: NSObject{
    var pressedYear = "2015"
    var pressedWeek = "0"
    var pressedDay = "0"
    var pressedDate = "0"
    var pressedPeriod:Double = 0
    var nextHolidayType = ""
    
    func currentDay() -> String{
        return pressedDay
    }
    func currentDate() -> String{
        return (pressedDate + " 01:00")
    }
    func currentMainDate() -> String{
        return pressedDate
    }
    
    func currentWeek() -> String{ //Return a string with the pressed Week
        return pressedWeek
    }
    
    func currentYear() -> String { //Return a string with the pressed Year
        return pressedYear
    }
    
    func startDate() -> NSDate { //Return a string with the first day of new period in new year
        switch pressedYear{
        case "2016":
            return createNSDate("2016-01-04")
        case "2017":
            return createNSDate("2017-01-02")
        case "2018":
            return createNSDate("2018-01-01")
        case "2019":
            return createNSDate("2018-12-31")
        case "2020":
            return createNSDate("2019-12-29")
        default:
            return createNSDate("2014-12-29")
        }
        
    }
    
    func getCurrentWeek() -> Int{
        let todayDate:NSDate = NSDate()
        let myCalendar:NSCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierISO8601)!
        let components = myCalendar.components(NSCalendarUnit.WeekOfYear, fromDate:todayDate)
        return components.weekOfYear
        
        
    }
    
    func createNSDate(date:String) -> NSDate{
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let todayDate = formatter.dateFromString(date)
        return todayDate!
    }
    
    
}
