//
//  DayView.swift
//  PayDay!
//
//  Created by Brian van den Heuvel on 9/22/15.
//  Copyright © 2015 Brian van den Heuvel. All rights reserved.
//

import UIKit
import CoreData

class DayView: UIViewController, UITableViewDelegate {
    var dayData = ["Maandag", "Dinsdag", "Woensdag", "Donderdag","Vrijdag","Zaterdag","Zondag"]
    var varDec = VariableDec()
    var appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var requested:[Hours] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        //Register Custom Cell
        varDec = (tabBarController as! VariableController).varDec
        let nib = UINib(nibName: "CustomCell", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "DailyCells")
        self.title = ("Week \(varDec.currentWeek())")
        let context:NSManagedObjectContext = appDel.managedObjectContext

        requested = Hours.returnDate(context) as! [Hours]
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillAppear(animated: Bool) {
        let context:NSManagedObjectContext = appDel.managedObjectContext
        requested = Hours.returnDate(context) as! [Hours]
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func configureTableView() {
        tableView.estimatedRowHeight = 100.0
        tableView.rowHeight = 80
    }
    
    func tableView(TableView: UITableView, numberOfRowsInSection section: Int)-> Int {
        return 7
    }
    
    func tableView(TableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell:DailyCell = self.tableView.dequeueReusableCellWithIdentifier("DailyCells") as! DailyCell
        cell.day.text = dayData[indexPath.row]
        cell.datum.text = firstDayOfWeek(Int(varDec.currentWeek())!, inYear: Int(varDec.currentYear())!,index: indexPath.row) as String
        let index:NSInteger = searchResultArray(cell.datum.text!)
        if index != -1 {
            cell.fromTime.text = stringFromDate(requested[index].startTime!)
            cell.toTime.text = stringFromDate(requested[index].endTime!)
            let (hours,minutes) = secondsToHoursMinutesSeconds(requested[index].totalTime as! Int)
            cell.totalTime.text = stringFromDateToString(hours, minutes: minutes) as String
        }else {
            cell.fromTime.text = nil
            cell.totalTime.text = nil
            cell.toTime.text = nil
        }
        return cell
    }
    
    func searchResultArray(currentCellDate: String)-> NSInteger{
        var returnInt:Int = -1
        for var i:Int = 0; i < requested.count; ++i{
            let dateAsString = requested[i].dateAsString
            if (dateAsString! == currentCellDate){
                returnInt = i
                
            }
        }
        return returnInt
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let currentCell = tableView.cellForRowAtIndexPath(indexPath) as! DailyCell
        performSegueWithIdentifier("PickerView", sender: nil)
        varDec.pressedDay = currentCell.day.text!
        varDec.pressedDate = currentCell.datum.text!
        varDec.pressedWeek = varDec.currentWeek()
    }
    
    func firstDayOfWeek(var week: Int, inYear year : Int, index: Int) -> NSString {
        let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        let components = NSDateComponents()
        var WeekdayNumber:Int = index + 2
        if WeekdayNumber == 8 {
            WeekdayNumber = 1
            week += 1
        }
        components.weekOfYear = week
        components.yearForWeekOfYear = year
        components.weekday = WeekdayNumber // First weekday of the week (Sunday = 1), index starts at 0.
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let date = calendar.dateFromComponents(components)!
        return dateFormatter.stringFromDate(date)
    }
    
    
    func stringFromDate(date: NSDate)->String{
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "hh:mm"
        return dateFormatter.stringFromDate(date)
    }
    func stringFromDateToString(hour: NSInteger, minutes:NSInteger)-> NSString{
        let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        let components = NSDateComponents()
        components.hour = hour as Int!
        components.minute = minutes as Int!
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "hh:mm"
        let date = calendar.dateFromComponents(components)!
        return dateFormatter.stringFromDate(date)
        
    }
    
    func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60)
    }
    
}
