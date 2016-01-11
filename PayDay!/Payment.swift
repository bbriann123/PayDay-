//
//  Payment.swift
//  PayDay!
//
//  Created by Brian van den Heuvel on 27/12/15.
//  Copyright © 2015 Brian van den Heuvel. All rights reserved.
//

import Foundation

class Payment {
    let contract = 12
    let allowance:Double = 12.25
    
    func getWorked(worked:Double) -> (allowance:Double, kptADV:Double, kptVacation:Double, kptADVWage:String, kptVacationWage:String, kptVacationAllowanceWage: String, kptWUKWage:String, kptGrossWage:String){
        var worked:Double = worked
        var allowance:Double = userDefaults().readDefaultsDouble("currentWage")
        var sick:Double = 0
        var bd:Double = 0
        allowance = floor(allowance * 4)/4
        let d:Double = worked// + allowance + sick + bd
        if contract <= 48{
            let d1:Double = d - Double(contract)
            if(d1 > 0 && contract != 0){
                let kptTVT = d1
                worked = worked-d1
            }
            let kptADV = 0.0901*d
            let kptVacation = 0.1109*d
            let kptVacationAllowance = 0.096100000000000005*d
            let kptWUK = 0.0327*d
            let kptGross = 1.3298000000000001*d
            let kptADVWage = NSString(format: "%.2f",(kptADV * allowance))
            let kptVacationWage = NSString(format: "%.2f",(kptVacation * allowance))
            let kptVacationAllowanceWage = NSString(format: "%.2f",(kptVacationAllowance * allowance))
            let kptWUKWage = NSString(format: "%.2f",(kptWUK * allowance))
            let kptGrossWage = NSString(format: "%.2f",(kptGross * allowance))
            return (allowance, kptADV, kptVacation, kptADVWage as String,kptVacationWage as String,kptVacationAllowanceWage as String ,kptWUKWage as String,kptGrossWage as String)
        }
        return (0.0,0.0,0.0,"","","","","")
    }
    
    func getDayOfWeek(today:NSDate)->Int {
        let todayDate = today
        let myCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        let myComponents = myCalendar.components(.Weekday, fromDate: todayDate)
        let weekDay = myComponents.weekday
        return weekDay
    }
    
    func isToeslagUur(date: NSDate, var startTime: Double, var endTime: Double, weekMoreThanThirtySix:Bool) -> (totaalUren:Double, totaalLoon:Double){
        print("\(date) - \(startTime) - \(endTime) - \(weekMoreThanThirtySix)")
        let weekdayNumber = getDayOfWeek(date)
        var vijfentwintigProcent = 0
        var vijftigProcent = 0
        var drieendertigProcent = 0
        var totaalToeslagLoon:Double = 0.0
        var drieendertigProcentLoon:Double = 0.0
        var vijftigProcentLoon:Double = 0.0
        var vijfentwintigProcentLoon:Double = 0.0
        var honderdProcent = 0
        var honderdProcentLoon:Double = 0.0
        //0,1225*25*4 =  12,25
        let formatter = NSNumberFormatter()
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 3
        var minutesToHundreds = Int(Double(String(formatter.stringFromNumber(startTime)!).componentsSeparatedByString(".")[1])!*1.6666666667)
        let remainingMinutesInHundreds = 100 - minutesToHundreds
        var remainderMinutes: Bool = false
        var remainderEndMinutes:Bool = false
        var remainingEndMinutes = Int(Double(String(formatter.stringFromNumber(endTime)!).componentsSeparatedByString(".")[1])!*1.6666666667)
        if remainingEndMinutes == 0{
            remainingEndMinutes = 100
        }
        var nextDay: Bool = false
        if remainingMinutesInHundreds != 100 {
            remainderMinutes = true
        }
        switch weekdayNumber{
            /* CASE MONDAY THRUE FRIDAY */
        case 2...6:
            for var x = 0.00; x < endTime; x++ {
                if endTime < startTime {
                    endTime = endTime+24
                }
                if startTime+x > 24.59 {
                    nextDay = true
                }
                
                if Double(String(startTime+x).componentsSeparatedByString(".")[0]) > endTime{
                    break
                }
                if Double(String(startTime+x).componentsSeparatedByString(".")[0]) > endTime-1{
                    remainderEndMinutes = true
                }
                if startTime+x >= 21 && startTime+x <= 24 && !nextDay{
                    if remainderMinutes {
                        vijftigProcent = vijftigProcent + Int(round(Double(remainingMinutesInHundreds)/1.6666666667))
                        remainderMinutes = false
                    }else{
                        vijftigProcent = vijftigProcent + Int(round(Double(minutesToHundreds)/1.6666666667))
                        if remainingEndMinutes != 100 && remainderEndMinutes{
                            vijftigProcent = vijftigProcent - Int(round(Double(100 - remainingEndMinutes)/1.6666666667))
                            remainingEndMinutes = 100
                        }
                        
                    }
                }
                if startTime+x < 6 || nextDay == true && startTime+x-24 < 6 {
                    if remainderMinutes {
                        vijftigProcent = vijftigProcent + Int(round(Double(remainingMinutesInHundreds)/1.6666666667))
                        remainderMinutes = false
                    }else{
                        vijftigProcent = vijftigProcent + Int(round(Double(minutesToHundreds)/1.6666666667))
                        if remainingEndMinutes != 100 && remainderEndMinutes{
                            vijftigProcent = vijftigProcent - Int(round(Double(100 - remainingEndMinutes)/1.6666666667))
                            remainingEndMinutes = 100
                        }
                    }
                    minutesToHundreds = 100
                }
                if startTime+x >= 6 && startTime+x < 7 && endTime >= 7{
                    if !weekMoreThanThirtySix{
                        if remainderMinutes {
                            vijfentwintigProcent = vijfentwintigProcent + Int(round(Double(remainingMinutesInHundreds)/1.6666666667))
                            remainderMinutes = false
                        }else {
                            vijfentwintigProcent = vijfentwintigProcent + Int(round(Double(minutesToHundreds)/1.6666666667))
                            if remainingEndMinutes != 100 && remainderEndMinutes{
                                vijfentwintigProcent = vijfentwintigProcent - Int(round(Double(100 - remainingEndMinutes)/1.6666666667))
                                remainingEndMinutes = 100
                            }
                        }
                    }else{
                        if remainderMinutes {
                            vijftigProcent = vijftigProcent + Int(round(Double(remainingMinutesInHundreds)/1.6666666667))
                            remainderMinutes = false
                        }else {
                            vijftigProcent = vijftigProcent + Int(round(Double(minutesToHundreds)/1.6666666667))
                            if remainingEndMinutes != 100 && remainderEndMinutes{
                                vijftigProcent = vijftigProcent - Int(round(Double(100 - remainingEndMinutes)/1.6666666667))
                                remainingEndMinutes = 100
                            }
                        }
                    }
                    minutesToHundreds = 100
                }
                if startTime+x >= 20 && startTime+x < 21{
                    if remainderMinutes {
                        drieendertigProcent = drieendertigProcent + Int(round(Double(remainingMinutesInHundreds)/1.6666666667))
                        remainderMinutes = false
                    }else {
                        drieendertigProcent = drieendertigProcent + Int(round(Double(minutesToHundreds)/1.6666666667))
                        if remainingEndMinutes != 100 && remainderEndMinutes{
                            drieendertigProcent = drieendertigProcent - Int(round(Double(100 - remainingEndMinutes)/1.6666666667))
                            remainingEndMinutes = 100
                        }
                    }
                    minutesToHundreds = 100
                }
                if x == 0.0 {
                    remainderMinutes = false
                    minutesToHundreds = 100
                }
            }
            /* CASE SATURDAY */
        case 7:
            
            for var x = 0.00; x < endTime; x++ {
                if endTime < startTime {
                    endTime = endTime+24
                }
                if startTime+x > 24.59 {
                    nextDay = true
                }
                
                if Double(String(startTime+x).componentsSeparatedByString(".")[0]) > endTime{
                    break
                }
                if Double(String(startTime+x).componentsSeparatedByString(".")[0]) > endTime-1{
                    remainderEndMinutes = true
                }
                if startTime+x >= 18 && startTime+x <= 24 && !nextDay{
                    if remainderMinutes {
                        vijftigProcent = vijftigProcent + Int(round(Double(remainingMinutesInHundreds)/1.6666666667))
                        remainderMinutes = false
                    }else{
                        vijftigProcent = vijftigProcent + Int(round(Double(minutesToHundreds)/1.6666666667))
                        if remainingEndMinutes != 100 && remainderEndMinutes{
                            vijftigProcent = vijftigProcent - Int(round(Double(100 - remainingEndMinutes)/1.6666666667))
                            remainingEndMinutes = 100
                        }
                        
                    }
                }
                if startTime+x < 6 || nextDay == true && startTime+x-24 < 6 {
                    if remainderMinutes {
                        vijftigProcent = vijftigProcent + Int(round(Double(remainingMinutesInHundreds)/1.6666666667))
                        remainderMinutes = false
                    }else{
                        vijftigProcent = vijftigProcent + Int(round(Double(minutesToHundreds)/1.6666666667))
                        if remainingEndMinutes != 100 && remainderEndMinutes{
                            vijftigProcent = vijftigProcent - Int(round(Double(100 - remainingEndMinutes)/1.6666666667))
                            remainingEndMinutes = 100
                        }
                    }
                    minutesToHundreds = 100
                }
                if startTime+x >= 6 && startTime+x < 7 && endTime >= 7{
                    if !weekMoreThanThirtySix{
                        if remainderMinutes {
                            vijfentwintigProcent = vijfentwintigProcent + Int(round(Double(remainingMinutesInHundreds)/1.6666666667))
                            remainderMinutes = false
                        }else {
                            vijfentwintigProcent = vijfentwintigProcent + Int(round(Double(100)/1.6666666667))
                            if remainingEndMinutes != 100 && remainderEndMinutes{
                                vijfentwintigProcent = vijfentwintigProcent - Int(round(Double(100 - remainingEndMinutes)/1.6666666667))
                                remainingEndMinutes = 100
                            }
                        }
                    }else{
                        if remainderMinutes {
                            vijftigProcent = vijftigProcent + Int(round(Double(remainingMinutesInHundreds)/1.6666666667))
                            remainderMinutes = false
                        }else {
                            vijftigProcent = vijftigProcent + Int(round(Double(100)/1.6666666667))
                            if remainingEndMinutes != 100 && remainderEndMinutes{
                                vijftigProcent = vijftigProcent - Int(round(Double(100 - remainingEndMinutes)/1.6666666667))
                                remainingEndMinutes = 100
                            }
                        }
                    }
                    minutesToHundreds = 100
                }
                if x == 0.0 {
                    remainderMinutes = false
                    minutesToHundreds = 100
                }
            }
            
        case 1:
            for var x = 0.00; x < endTime; x++ {
                if endTime < startTime {
                    endTime = endTime+24
                }
                if startTime+x > 24.59 {
                    nextDay = true
                }
                if Double(String(startTime+x).componentsSeparatedByString(".")[0]) >= endTime{
                    break
                }
                if Double(String(startTime+x).componentsSeparatedByString(".")[0]) > endTime-1{
                    remainderEndMinutes = true
                }
                if remainderMinutes {
                    honderdProcent = honderdProcent + Int(round(Double(remainingMinutesInHundreds)/1.6666666667))
                    remainderMinutes = false
                }else{
                    honderdProcent = honderdProcent + Int(round(Double(100)/1.6666666667))
                    if remainingEndMinutes != 100 && remainderEndMinutes{
                        honderdProcent = honderdProcent - Int(round(Double(100 - remainingEndMinutes)/1.6666666667))
                        remainingEndMinutes = 100
                    }
                    
                }
                if x == 0.0 {
                    remainderMinutes = false
                    minutesToHundreds = 100
                }
            }
            
        default: print("error")
        }
        drieendertigProcentLoon = ((allowance/100)*1.33)*(Double(drieendertigProcent)*1.6666666667)
        vijftigProcentLoon = ((allowance/100)*1.50)*(Double(vijftigProcent)*1.6666666667)
        vijfentwintigProcentLoon = ((allowance/100)*1.25)*(Double(vijfentwintigProcent)*1.6666666667)
        honderdProcentLoon = ((allowance/100)*2)*(Double(honderdProcent)*1.6666666667)
        let totaalTijd:Double = Double(vijftigProcent + drieendertigProcent + vijfentwintigProcent + honderdProcent)
        totaalToeslagLoon = drieendertigProcentLoon + vijftigProcentLoon + vijfentwintigProcentLoon + honderdProcentLoon
        return (totaalTijd, totaalToeslagLoon)
        
    }
}