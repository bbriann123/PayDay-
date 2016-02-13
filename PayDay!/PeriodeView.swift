//
//  PeriodeView.swift
//  PayDay!
//
//  Created by Brian van den Heuvel on 9/22/15.
//  Copyright © 2015 Brian van den Heuvel. All rights reserved.
//
/*  This class shows the period's in a year after 'selecting' a year.
*  Starting at the first week of a year calculating 4 weeks for each period.
*  Shows the first day of the week and hours working in that week.
*/

import UIKit
import CoreData
import GoogleMobileAds

class PeriodeView: UIViewController, UITableViewDelegate{ 
    //Declare variables.
    var appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var requested:[Hours] = []
    var yearArray:[Hours] = []
    var weekArray:[Hours] = []
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var bannerView: GADBannerView!
    var varDec = VariableDec()
    
    
    //First load, fires when view gets called for the first time
    override func viewDidLoad() {
        super.viewDidLoad()
        bannerView.adUnitID = "ca-app-pub-1488852759580167/4988475532"
        bannerView.rootViewController = self
        bannerView.loadRequest(GADRequest())
        varDec = (tabBarController as! VariableController).varDec
        let context:NSManagedObjectContext = appDel.managedObjectContext
        requested = Hours.returnDate(context) as! [Hours]
        searchResultArrayYear()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    //Runs when navigating back to the view, Reloads all data to add total hours or subtract when deleted.
    override func viewWillAppear(animated: Bool) {
        let context:NSManagedObjectContext = appDel.managedObjectContext
        yearArray.removeAll()
        weekArray.removeAll()
        requested = Hours.returnDate(context) as! [Hours]
        searchResultArrayYear()
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int{
        //return the number of sections
        return 13
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        let yearToCheck = Int(varDec.currentYear())! + 1
        if yearToCheck % 400 == 0 || yearToCheck  % 4 == 0 && yearToCheck % 100 != 0{
            if section == 12{
                return 5
            }else{ return 4 }
        }else{ return 4 }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell: UITableViewCell = UITableViewCell(style:UITableViewCellStyle.Subtitle, reuseIdentifier: "MyTestCell")
        let section = indexPath.section
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        let weekNummer = String(getWeek(addDays(varDec.startDate(), index: indexPath.row, section:section))!)
        searchCurrentWeek(weekNummer)
        let (hours, minutes) = secondsToHoursMinutesSeconds(findTotalHoursPerWeek())
        cell.textLabel!.text = weekNummer
        
        if (hours > 0 ) {
            if let yearWrap = Int(varDec.currentYear()){
                cell.detailTextLabel!.text = "Starts at \(firstDayOfWeek(Int(weekNummer)!, inYear: yearWrap, inSection: section)) --- \(hours):\(minutes)"
            }
        }else{
            if let yearWrap = Int(varDec.currentYear()){
                cell.detailTextLabel!.text = "Starts at \(firstDayOfWeek(Int(weekNummer)!, inYear: yearWrap, inSection: section))"
            }
        }
        //Check for current week and make cell stand out with a nice fancy Color
        let date = NSDate()
        let Calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierISO8601)!
        let Components = Calendar.components([.WeekOfYear, .Year], fromDate: date)
        let week = Components.weekOfYear
        let year = Components.year
        weekArray.removeAll()
        if(String(weekNummer) == String(week) && String(year) == varDec.currentYear()){
            cell.backgroundColor = UIColor(red: 190/255, green: 190/255, blue: 190/255, alpha: 	0.6)
        }
        return cell
    }
    
    //Gets all results from 'requested' array and puts them in a seperate array.
    func searchResultArrayYear(){
        for i:Int in 0...requested.count{
            let yearNumber = requested[i].yearNumber
            if (yearNumber! == Int(varDec.pressedYear)!){
                yearArray.append(requested[i])
            }
        }
    }
    
    //Gets the results corrosponding with the week being created (cell number) and stores them in a array.
    func searchCurrentWeek(currentCellWeek: String){
        for i:Int in 0...yearArray.count{
            let weekNumber = yearArray[i].weekNumber
            if(weekNumber != nil){
                if (weekNumber! == currentCellWeek){
                    weekArray.append(yearArray[i])
                }
            }
        }
    }
    
    //Searches the weekArray array and adds all totalhours from each entity to create the total worked hours.
    func findTotalHoursPerWeek()-> NSInteger{
        var totalHours = 0
        for i:Int in 0...weekArray.count{
            totalHours += Int(weekArray[i].totalTime!)
        }
        return totalHours
    }
    
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String?{
        let newSection = section + 1
        return "Periode \(newSection) - Year \(varDec.currentYear())"
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("weekView", sender: nil)
        let currentCell = tableView.cellForRowAtIndexPath(indexPath)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        varDec.pressedWeek = currentCell!.textLabel!.text!
        varDec.pressedPeriod = Double(indexPath.section)+1
    }
    
    func firstDayOfWeek(week: Int, inYear year : Int, inSection:Int) -> NSString {
        let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierISO8601)!
        let components = NSDateComponents()
        components.weekOfYear = week
        components.yearForWeekOfYear = year
        components.weekday = 2 // First weekday of the week (Sunday = 1)
        let dateFormatter = NSDateFormatter()
        if week > 50 && inSection == 0{
            components.yearForWeekOfYear = year - 1
        }
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let date = calendar.dateFromComponents(components)!
        return dateFormatter.stringFromDate(date)
    }
    
    
    func getWeek(today:NSDate)->Int? {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let myCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierISO8601)!
        let myComponents = myCalendar.components(.WeekOfYear, fromDate: today)
        let weekNumber = myComponents.weekOfYear
        return weekNumber
    }
    
    func addDays(date: NSDate, index:Int, section:Int) -> NSDate {
        // calculation $additionalDays
        let additionalDays = ((28*section) + (7*index))
        // adding $additionalDays
        let components = NSDateComponents()
        components.day = additionalDays
        
        // important: NSCalendarOptions(0)
        let futureDate = NSCalendar.currentCalendar()
            .dateByAddingComponents(components, toDate: date, options: NSCalendarOptions(rawValue: 0))
        return futureDate!
    }
    
    func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60)
    }
}