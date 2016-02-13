//
//  FirstViewController.swift
//  PayDay!
//
//  Created by Brian van den Heuvel on 18/12/15.
//  Copyright © 2015 Brian van den Heuvel. All rights reserved.
//

import UIKit
import CoreData
import iAd

class FirstViewController: UIViewController, ADBannerViewDelegate {
    @IBOutlet weak var textColum: UILabel!
    @IBOutlet weak var wageColumn: UILabel!
    @IBOutlet weak var hourColumn: UILabel!
    @IBOutlet weak var Periode: UILabel!
    
    var varDec = VariableDec()
    var appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var requested:[Hours] = []
    var currentPeriod:[Hours] = []
    let payment = Payment()
    var hourlyWage = 0.0
    var currentPeriodNumber = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setPeriod()
        let context:NSManagedObjectContext = appDel.managedObjectContext
        var settings = savedSettings.returnSettings(context) as! [savedSettings]
        if !settings.isEmpty {
            hourlyWage = Double(settings[0].hourlyWage!)
            payment.allowance = hourlyWage
            payment.contract = Int(settings[0].contractHours!)
        }
        let tbc = tabBarController as! VariableController
        if hourlyWage <= 0.1{
            let alert = UIAlertController(title: "Ontbrekende instelling", message: "Uurloon niet ingesteld!", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (UIAlertAction) in
                self.tabBarController?.selectedIndex = 2
                }))
            self.presentViewController(alert, animated: true, completion: {})
        }
        // Do any additional setup after loading the view, typically from a nib.
        varDec = tbc.varDec
        requested = Hours.returnDate(context) as! [Hours]
        Periode.text = "Periode \(currentPeriodNumber)"
        self.currentPeriod.removeAll()
    }
    override func viewDidAppear(animated: Bool) {
        setPeriod()
        let context:NSManagedObjectContext = appDel.managedObjectContext
        var settings = savedSettings.returnSettings(context) as! [savedSettings]
        if !settings.isEmpty{
            hourlyWage = Double(settings[0].hourlyWage!)
            payment.allowance = hourlyWage
            payment.contract = Int(settings[0].contractHours!)
        }
        if hourlyWage <= 0.1{
            let alert = UIAlertController(title: "Ontbrekende instelling", message: "Uurloon niet ingesteld!", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (UIAlertAction) in
                self.tabBarController?.selectedIndex = 2
            }))
            alert.addAction(UIAlertAction(title:"Cancel", style:UIAlertActionStyle.Cancel, handler:  nil  ))
            self.presentViewController(alert, animated: true, completion: {})
        }
        self.currentPeriod.removeAll()
        requested = Hours.returnDate(context) as! [Hours]
        searchResultArray(currentPeriodNumber)
        Periode.text = "Periode \(currentPeriodNumber)"
        printTotalTimeInPeriod()
    }
    
    func setPeriod(){
        let currentWeek = varDec.getCurrentWeek()
        switch (currentWeek){
        case 1...4: currentPeriodNumber = 1
        case 5...8: currentPeriodNumber = 2
        case 9...12: currentPeriodNumber = 3
        case 13...16: currentPeriodNumber = 4
        case 17...20: currentPeriodNumber = 5
        case 21...24: currentPeriodNumber = 6
        case 25...28: currentPeriodNumber = 7
        case 29...32: currentPeriodNumber = 8
        case 33...36: currentPeriodNumber = 9
        case 37...40: currentPeriodNumber = 10
        case 41...44: currentPeriodNumber = 11
        case 45...48: currentPeriodNumber = 12
        case 49...54: currentPeriodNumber = 13
        default: currentPeriodNumber = 1
        }
    }
    override func viewDidDisappear(animated: Bool) {
        self.currentPeriod.removeAll()
        let context:NSManagedObjectContext = appDel.managedObjectContext
        requested = Hours.returnDate(context) as! [Hours]
        searchResultArray(currentPeriodNumber)
    }
    func determineMoreThanTwelve() -> [Int: Int] {
        var totalHours = [Int:Int]()
        for l in 0 ..< currentPeriod.count{
            if totalHours[Int(currentPeriod[l].weekNumber! as String)!] != nil {
                let oldValue = totalHours.updateValue(0, forKey: Int(currentPeriod[l].weekNumber! as String)!)
                totalHours.updateValue(oldValue!+Int(currentPeriod[l].totalTime!), forKey: Int(currentPeriod[l].weekNumber! as String)!)
            }else{
                totalHours.updateValue(Int(currentPeriod[l].totalTime!), forKey: Int(currentPeriod[l].weekNumber! as String)!)
            }
        }
        return totalHours
    }
    func getBonusHours(weekNumber: Int) -> (totalLoon: Double, totalUren:Double){
        var totalLoon:Double = 0.0
        var totalUren:Double = 0.0
        for l in 0 ..< currentPeriod.count{
            if Int(currentPeriod[l].weekNumber! as String)! == weekNumber {
                totalLoon = totalLoon + payment.isToeslagUur(currentPeriod[l].date!, startTime: getHourMinute(currentPeriod[l].startTime!), endTime: getHourMinute(currentPeriod[l].endTime!), weekMoreThanThirtySix: false).totaalLoon
                totalUren = totalUren + payment.isToeslagUur(currentPeriod[l].date!, startTime: getHourMinute(currentPeriod[l].startTime!), endTime: getHourMinute(currentPeriod[l].endTime!), weekMoreThanThirtySix: false).totaalUren

            }
        }
        return (totalLoon, totalUren)
    }
    
    func getHourMinute(date: NSDate) -> (Double){
        let calendar = NSCalendar.currentCalendar()
        let comp = calendar.components([.Hour, .Minute], fromDate: date)
        let hour = comp.hour
        let minute = comp.minute
        return Double("\(hour).\(minute)")!
    }
    
    func printTotalTimeInPeriod(){
        let weeks = determineMoreThanTwelve()
        var toeslag = [Int: (Double, Double)]()
        var totalTime = 0
        var toeslagTotal:Double = 0.0
        var toeslagUren:Double = 0.0
        for x in 0 ..< currentPeriod.count{
            totalTime = totalTime + Int(currentPeriod[x].totalTime!)
        }
        for (key, value) in weeks{
            if(value/3600 > 12){
                let holder = getBonusHours(key)
                toeslag.updateValue((holder.totalLoon,holder.totalUren), forKey: key)
            }
        }
        for value in toeslag.values {
            toeslagUren = toeslagUren + value.1
            toeslagTotal = toeslagTotal + value.0
        }
        let (Hours,Minutes) = secondsToHoursMinutesSeconds(totalTime)
        //convert tuple to string concatenated string, multiple minutes to 100 value's (20 min = 33 etc.. (minutes*   1.6666666667)) then convert to Double so 12.25 becomes 12.42
        let totalTimeDouble = Double("\(Hours).\(Int(Double(Minutes)*1.6666666667))")
        let printValue = payment.getWorked(totalTimeDouble!, toeslagGeld: toeslagTotal, toeslagUren: toeslagUren/60)
        var textColumText:String = ""
        if printValue != nil{
            for (key, _) in printValue!{
                if key != "uurloon"{
                    let formatKey = String(key.characters.dropFirst(2))
                    textColumText = textColumText + formatKey + "\n"
                }
            }
            textColum.text = textColumText
         //   textColum.sizeToFit()
            var hourColumText:String = ""
            for (key, item) in printValue!{
                if key != "uurloon"{
                    if item.0 != nil {
                        hourColumText = hourColumText + String(item.0!) + "\n"
                    }else{
                        hourColumText = hourColumText + "\n" + " "
                    }
                }
            }
            hourColumn.text = hourColumText
           // hourColumn.sizeToFit()
            var wageColumnText:String = ""
            for (key, item) in printValue!{
                if key != "uurloon"{
                    if item.1 != nil {
                        wageColumnText = wageColumnText + String(item.1!).value + "\n"
                    }else{
                        wageColumnText = wageColumnText + "\n" + " "
                    }
                }
                
            }
            wageColumn.text = wageColumnText
          //  wageColumn.sizeToFit()
        

        }else{
            wageColumn.text = ""
            hourColumn.text = ""
            textColum.text = ""
            let alert = UIAlertController(title: "Ontbrekende instelling", message: "Voor huidige perdiode zijn geen uren ingevuld!", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Instellen", style: UIAlertActionStyle.Default, handler: { (UIAlertAction) in
                self.tabBarController?.selectedIndex = 0
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
            self.presentViewController(alert, animated: true, completion: {})
        }
    }
    func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60)
    }
    func searchResultArray(currentPeriod: Int){
        for i:Int in 0 ..< requested.count{
            let periodNumber:Int = Int(requested[i].periodeNumber!)
            if (periodNumber == currentPeriod){
                self.currentPeriod.append(requested[i])
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
extension NSString {
    var value:String {
        let appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context:NSManagedObjectContext = appDel.managedObjectContext
        var settings = savedSettings.returnSettings(context) as! [savedSettings]
        if !settings.isEmpty{
            let userDef = String(settings[0].currency!)
            switch(userDef){
            case "€":
                return ("€ \(self)")
            case "$": return ("$ \(self)")
            case "£": return ("£ \(self)")
            case "¥": return ("¥ \(self)")
            case "CHF": return ("CHF \(self)")
            default: return ("€ \(self)")
            }
        }else{
            return ("€ \(self)")
        }
    }
}