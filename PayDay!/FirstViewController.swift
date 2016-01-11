//
//  FirstViewController.swift
//  PayDay!
//
//  Created by Brian van den Heuvel on 18/12/15.
//  Copyright © 2015 Brian van den Heuvel. All rights reserved.
//

import UIKit
import CoreData

class FirstViewController: UIViewController {
    
    @IBOutlet weak var textColum: UILabel!
    @IBOutlet weak var wageColumn: UILabel!
    @IBOutlet weak var hourColumn: UILabel!
    
    var varDec = VariableDec()
    var appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var requested:[Hours] = []
    var currentPeriod:[Hours] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        let tbc = tabBarController as! VariableController
        if userDefaults().readDefaultsDouble("currentWage") <= 0.1{
            print("true")
            let alert = UIAlertController(title: "Ontbrekende instelling", message: "Uurloon niet ingesteld!", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (UIAlertAction) in
                self.tabBarController?.selectedIndex = 2
                }))
            self.presentViewController(alert, animated: true, completion: {})
        }
        // Do any additional setup after loading the view, typically from a nib.
        varDec = tbc.varDec
        let context:NSManagedObjectContext = appDel.managedObjectContext
        requested = Hours.returnDate(context) as! [Hours]
        self.currentPeriod.removeAll()
    }
    override func viewDidAppear(animated: Bool) {
        if userDefaults().readDefaultsDouble("currentWage") <= 0.1{
            print("true")
            let alert = UIAlertController(title: "Ontbrekende instelling", message: "Uurloon niet ingesteld!", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (UIAlertAction) in
                self.tabBarController?.selectedIndex = 2
            }))
            alert.addAction(UIAlertAction(title:"Cancel", style:UIAlertActionStyle.Cancel, handler:  nil  ))
            self.presentViewController(alert, animated: true, completion: {})
        }
        self.currentPeriod.removeAll()
        let context:NSManagedObjectContext = appDel.managedObjectContext
        requested = Hours.returnDate(context) as! [Hours]
        searchResultArray(1)
        printTotalTimeInPeriod()
        getBonusHours()
    }
    override func viewDidDisappear(animated: Bool) {
        self.currentPeriod.removeAll()
        let context:NSManagedObjectContext = appDel.managedObjectContext
        requested = Hours.returnDate(context) as! [Hours]
        searchResultArray(1)
        printTotalTimeInPeriod()
    }
    
    func getBonusHours() -> [Int]{
        var max = 0
        var totalHours:[Int] = []
        var totalloon:Double = 0.0
        var totaluren:Double = 0.0
        for var l = 0; l < currentPeriod.count; ++l{
            if Int(currentPeriod[l].weekNumber! as String)! > max {
                max = Int(currentPeriod[l].weekNumber! as String)!
                totalHours.append(Int(currentPeriod[l].totalTime!))
            }else{
                totalHours[max-1] = totalHours[max-1] + Int(currentPeriod[l].totalTime!)
            }
            print(getHourMinute(currentPeriod[l].startTime!))
            print(getHourMinute(currentPeriod[l].endTime!))
            print("-----")
            totalloon = totalloon + Payment().isToeslagUur(currentPeriod[l].date!, startTime: getHourMinute(currentPeriod[l].startTime!), endTime: getHourMinute(currentPeriod[l].endTime!), weekMoreThanThirtySix: false).totaalLoon
            totaluren = totaluren + Payment().isToeslagUur(currentPeriod[l].date!, startTime: getHourMinute(currentPeriod[l].startTime!), endTime: getHourMinute(currentPeriod[l].endTime!), weekMoreThanThirtySix: false).totaalUren
            print(totalloon)
            print(totaluren)
            print(currentPeriod[l].totalTime)
            print("-----")
        }
        print(totalloon)
        print(totaluren)
        return totalHours
    }
    
    func getHourMinute(date: NSDate) -> (Double){
        let calendar = NSCalendar.currentCalendar()
        let comp = calendar.components([.Hour, .Minute], fromDate: date)
        let hour = comp.hour
        let minute = comp.minute
        return Double("\(hour).\(minute)")!
    }
    
    func printTotalTimeInPeriod(){
        var totalTime = 0
        for var x = 0; x < currentPeriod.count; ++x{
            totalTime = totalTime + Int(currentPeriod[x].totalTime!)
        }
        let (Hours,Minutes) = secondsToHoursMinutesSeconds(totalTime)
        //convert tuple to string concatenated string, multiple minutes to 100 value's (20 min = 33 etc.. (minutes*   1.6666666667)) then convert to Double so 12.25 becomes 12.42
        let totalTimeDouble = Double("\(Hours).\(Int(Double(Minutes)*1.6666666667))")
        let printValue = Payment().getWorked(totalTimeDouble!)
        let textColumText = "Gewerkt\n" + "ADV\n"+"Vakantie uren\n"+"Vakantie toeslag\n"+"Winstuitkering\n"+"Bruto loon"
        textColum.text = textColumText
        textColum.sizeToFit()
        let hourColumText = "\(totalTimeDouble!) uur\n\(NSString(format:"%.2f uur",printValue.kptADV))\n\(NSString(format:"%.2f uur",printValue.kptVacation))"
        hourColumn.text = hourColumText
        hourColumn.sizeToFit()
        let wageColumnText = "\(String(totalTimeDouble!*printValue.allowance).value)\n \(String(printValue.kptADVWage).value)\n\(String(printValue.kptVacationWage).value)\n \(String(printValue.kptVacationAllowanceWage).value)\n \(String(printValue.kptWUKWage).value)\n \(String(printValue.kptGrossWage).value)"
        wageColumn.text = wageColumnText
        wageColumn.sizeToFit()
        
    }
    func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60)
    }
    func searchResultArray(currentPeriod: Int){
        for var i:Int = 0; i < requested.count; ++i{
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
        let userDef = userDefaults().readDefaultsString("currency")
        switch(userDef){
        case "€":
            return ("€ \(self)")
        case "$": return ("$ \(self)")
        case "£": return ("£ \(self)")
        case "¥": return ("¥ \(self)")
        case "CHF": return ("CHF \(self)")
        default: return ("€ \(self)")
        }
    }
}