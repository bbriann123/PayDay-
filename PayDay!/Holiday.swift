//
//  Holiday.swift
//  PayDay!
//
//  Created by Brian van den Heuvel on 20/12/15.
//  Copyright © 2015 Brian van den Heuvel. All rights reserved.
//

import Foundation
class Holiday{
    
    var date:NSDate = NSDate()
    var type:String = ""
    
    init(newDate:NSDate, newType:String){
        self.date = newDate
        self.type = newType
    }
}
class CreateHoliday{
    var holidays2016:Array <Holiday> = []
    var holidays2017:Array <Holiday> = []
    var holidays2018:Array <Holiday> = []
    var holidays2019:Array <Holiday> = []
    var holidays2020:Array <Holiday> = []
    
    init(){
        createHolidays2016()
        createHolidays2017()
        createHolidays2018()
        createHolidays2019()
        createHolidays2020()
    }
    func createHolidays2016(){
        holidays2016.append(Holiday(newDate: stringToDate("01-01-2016 01:00"),newType: "Nieuwjaarsdag"))
        holidays2016.append(Holiday(newDate: stringToDate("27-03-2016 01:00"), newType: "1e Paasdag"))
        holidays2016.append(Holiday(newDate: stringToDate("28-03-2016 01:00"), newType: "2e Paasdag"))
        holidays2016.append(Holiday(newDate: stringToDate("27-04-2016 01:00"), newType: "Koningsdag"))
        holidays2016.append(Holiday(newDate: stringToDate("05-05-2016 01:00"), newType: "Hemelvaartsdag"))
        holidays2016.append(Holiday(newDate: stringToDate("15-05-2016 01:00"), newType: "1e Pinksterdag"))
        holidays2016.append(Holiday(newDate: stringToDate("16-05-2016 01:00"), newType: "2e Pinksterdag"))
        holidays2016.append(Holiday(newDate: stringToDate("25-12-2016 01:00"), newType: "1e Kerstdag"))
        holidays2016.append(Holiday(newDate: stringToDate("26-12-2016 01:00"), newType: "2e Kerstdag"))
    }
    func createHolidays2017(){
        holidays2017.append(Holiday(newDate: stringToDate("01-01-2017 01:00"),newType: "Nieuwjaarsdag"))
        holidays2017.append(Holiday(newDate: stringToDate("16-04-2017 01:00"), newType: "1e Paasdag"))
        holidays2017.append(Holiday(newDate: stringToDate("17-04-2017 01:00"), newType: "2e Paasdag"))
        holidays2017.append(Holiday(newDate: stringToDate("27-04-2017 01:00"), newType: "Koningsdag"))
        holidays2017.append(Holiday(newDate: stringToDate("25-05-2017 01:00"), newType: "Hemelvaartsdag"))
        holidays2017.append(Holiday(newDate: stringToDate("04-06-2017 01:00"), newType: "1e Pinksterdag"))
        holidays2017.append(Holiday(newDate: stringToDate("05-06-2017 01:00"), newType: "2e Pinksterdag"))
        holidays2017.append(Holiday(newDate: stringToDate("25-12-2017 01:00"), newType: "1e Kerstdag"))
        holidays2017.append(Holiday(newDate: stringToDate("26-12-2017 01:00"), newType: "2e Kerstdag"))
    }
    
    func createHolidays2018(){
        holidays2018.append(Holiday(newDate: stringToDate("01-01-2018 01:00"),newType: "Nieuwjaarsdag"))
        holidays2018.append(Holiday(newDate: stringToDate("01-04-2018 01:00"), newType: "1e Paasdag"))
        holidays2018.append(Holiday(newDate: stringToDate("02-04-2018 01:00"), newType: "2e Paasdag"))
        holidays2018.append(Holiday(newDate: stringToDate("27-04-2018 01:00"), newType: "Koningsdag"))
        holidays2018.append(Holiday(newDate: stringToDate("10-05-2018 01:00"), newType: "Hemelvaartsdag"))
        holidays2018.append(Holiday(newDate: stringToDate("20-05-2018 01:00"), newType: "1e Pinksterdag"))
        holidays2018.append(Holiday(newDate: stringToDate("21-05-2018 01:00"), newType: "2e Pinksterdag"))
        holidays2018.append(Holiday(newDate: stringToDate("25-12-2018 01:00"), newType: "1e Kerstdag"))
        holidays2018.append(Holiday(newDate: stringToDate("26-12-2018 01:00"), newType: "2e Kerstdag"))
    }
    func createHolidays2019(){
        holidays2019.append(Holiday(newDate: stringToDate("01-01-2019 01:00"),newType: "Nieuwjaarsdag"))
        holidays2019.append(Holiday(newDate: stringToDate("21-04-2019 01:00"), newType: "1e Paasdag"))
        holidays2019.append(Holiday(newDate: stringToDate("22-04-2019 01:00"), newType: "2e Paasdag"))
        holidays2019.append(Holiday(newDate: stringToDate("27-04-2019 01:00"), newType: "Koningsdag"))
        holidays2019.append(Holiday(newDate: stringToDate("30-05-2019 01:00"), newType: "Hemelvaartsdag"))
        holidays2019.append(Holiday(newDate: stringToDate("09-05-2019 01:00"), newType: "1e Pinksterdag"))
        holidays2019.append(Holiday(newDate: stringToDate("10-05-2019 01:00"), newType: "2e Pinksterdag"))
        holidays2019.append(Holiday(newDate: stringToDate("25-12-2019 01:00"), newType: "1e Kerstdag"))
        holidays2019.append(Holiday(newDate: stringToDate("26-12-2019 01:00"), newType: "2e Kerstdag"))
    }
    func createHolidays2020(){
        holidays2020.append(Holiday(newDate: stringToDate("01-01-2020 01:00"),newType: "Nieuwjaarsdag"))
        holidays2020.append(Holiday(newDate: stringToDate("12-04-2020 01:00"), newType: "1e Paasdag"))
        holidays2020.append(Holiday(newDate: stringToDate("13-04-2020 01:00"), newType: "2e Paasdag"))
        holidays2020.append(Holiday(newDate: stringToDate("27-04-2020 01:00"), newType: "Koningsdag"))
        holidays2020.append(Holiday(newDate: stringToDate("05-05-2020 01:00"), newType: "Bevrijdingsdag"))
        holidays2020.append(Holiday(newDate: stringToDate("21-05-2020 01:00"), newType: "Hemelvaartsdag"))
        holidays2020.append(Holiday(newDate: stringToDate("31-05-2020 01:00"), newType: "1e Pinksterdag"))
        holidays2020.append(Holiday(newDate: stringToDate("01-06-2020 01:00"), newType: "2e Pinksterdag"))
        holidays2020.append(Holiday(newDate: stringToDate("25-12-2020 01:00"), newType: "1e Kerstdag"))
        holidays2020.append(Holiday(newDate: stringToDate("26-12-2020 01:00"), newType: "2e Kerstdag"))
    }
    
    func stringToDate(dateString: String) -> NSDate {
        let dateMakerFormatter = NSDateFormatter()
        dateMakerFormatter.calendar = NSCalendar.currentCalendar()
        dateMakerFormatter.dateFormat = "dd-MM-yyyy HH:mm"
        let date:NSDate = dateMakerFormatter.dateFromString(dateString)!
        return date
    }
    func getHolidays(year: String) -> Array<Holiday>{
        switch year{
            case "2016": return holidays2016
            case "2017": return holidays2017
            case "2018": return holidays2018
            case "2019": return holidays2019
            case "2020": return holidays2020
            default: return holidays2016
        }
    }
    func nextHoliday(z:Array<Holiday>, firstDayOfWeek:NSDate) -> Holiday?{
        outerLoop: for x in 0...z.count{
            for days in 0...14{
                let Calendar = NSCalendar.currentCalendar()
                var date = firstDayOfWeek
                let components = NSDateComponents()
                components.setValue(days, forComponent: NSCalendarUnit.Day);
                date = Calendar.dateByAddingComponents(components, toDate: date, options: NSCalendarOptions(rawValue: 0))!
                if(date == z[x].date){
                    return z[x]
                }
            }
        }
        return nil
    }

}