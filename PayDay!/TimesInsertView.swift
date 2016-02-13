//
//  TimesInsertView.swift
//  PayDay!
//
//  Created by Brian van den Heuvel on 9/23/15.
//  Copyright © 2015 Brian van den Heuvel. All rights reserved.
//

import UIKit
import CoreData

class TimesInsertView: UIViewController, UIPickerViewDelegate {
    var varDec = VariableDec()
    var appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    var requested:[Hours] = []
    @IBAction func deleteData(sender: AnyObject) {
        let context:NSManagedObjectContext = appDel.managedObjectContext
        let index = searchResultArray(varDec.currentMainDate())
        if requested.count > 0{
            let entityToDelete = requested[index].dateAsString
            showAlertDeleteView(context, entityToDelete: entityToDelete as! String)
        }
        
    }
    @IBAction func saveData(sender: AnyObject) {
        let context:NSManagedObjectContext = appDel.managedObjectContext
        let dateMakerFormatter = NSDateFormatter()
        dateMakerFormatter.calendar = NSCalendar.currentCalendar()
        dateMakerFormatter.dateFormat = "dd-MM-yyyy HH:mm"
        let date = dateMakerFormatter.dateFromString(varDec.currentDate())!
        let startTime = "\(Int(hours[timePicker.selectedRowInComponent(0)])!).\(Int(minutes[timePicker.selectedRowInComponent(1)])!)"
        let endTime = "\(Int(hours[timePicker.selectedRowInComponent(3)])!).\(Int(minutes[timePicker.selectedRowInComponent(4)])!)"
        let pauze = showBreaks(Double(startTime)!, endTime: Double(endTime)!)
        let timeInterval:NSTimeInterval = differenceBetweenTimes(hours[timePicker.selectedRowInComponent(0)], fromMinute: minutes[timePicker.selectedRowInComponent(1)], toHour: hours[timePicker.selectedRowInComponent(3)], toMinute: minutes[timePicker.selectedRowInComponent(4)], date: date, pauze: pauze)
        let startEndDate = returnStartEndDate(hours[timePicker.selectedRowInComponent(0)], fromMinute: minutes[timePicker.selectedRowInComponent(1)], toHour: hours[timePicker.selectedRowInComponent(3)], toMinute: minutes[timePicker.selectedRowInComponent(4)], date: date)
        showBreaks(Double(startTime)!, endTime: Double(endTime)!)
        Hours.insertTimes(date, startTime: startEndDate.startTime, endTime: startEndDate.endTime, totalTime: timeInterval, dateAsString: varDec.currentMainDate(), periodeNumber: varDec.pressedPeriod, yearNumber: Double(varDec.pressedYear)!, weekNumber: varDec.pressedWeek, context: context)
        showAlertView()
    }
    
    @IBOutlet weak var timePicker: UIPickerView!
    let hours:[String] = ["0","1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24"]
    let minutes:[String] = ["00","05","10","15","20","25","30","35","40","45","50","55"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        varDec = (tabBarController as! VariableController).varDec
        // Use :
        self.navigationItem.titleView = setTitle(varDec.currentMainDate(), subtitle: varDec.currentDay())
        let context:NSManagedObjectContext = appDel.managedObjectContext
        requested = Hours.returnDate(context) as! [Hours]
    }
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    func numberOfComponentsInPickerView(pickerView: UIPickerView!) -> Int {
        return 5
    }
    
    func pickerView(pickerView: UIPickerView!, numberOfRowsInComponent component: Int) -> Int {
        if (component == 0 || component == 3){
            return hours.count
        }
        if(component == 2){
            return 1
        }
        return minutes.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if component == 0{
            return hours[row]
        }else if component == 1{
            return minutes[row]
        }else if component == 2{
            return "-"
        }else if component == 3{
            return hours[row]
        }
        
        return minutes[row]
        
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let hourOne = Int(hours[timePicker.selectedRowInComponent(0)])!
        let hourTwo = Int(hours[timePicker.selectedRowInComponent(3)])!
        let minutesOne = Int(minutes[timePicker.selectedRowInComponent(1)])!
        let minutesTwo = Int(minutes[timePicker.selectedRowInComponent(4)])!
        //Uptime
        if(component == 0 && hourOne > hourTwo){
            timePicker.selectRow(row, inComponent: (component + 3), animated: true)
        }
        if (component == 1 && hourOne == hourTwo && minutesOne > minutesTwo){
            timePicker.selectRow(row, inComponent: (component + 3), animated: true)
        }
        //Downtime
        if(component == 3 && hourTwo < hourOne){
            timePicker.selectRow(row, inComponent: (component - 3), animated: true)
        }
        if (component == 4 && hourOne == hourTwo && minutesTwo < minutesOne){
            timePicker.selectRow(row, inComponent: (component - 3), animated: true)
        }
    }
    
    func setTitle(title:String, subtitle:String) -> UIView {
        let titleLabel = UILabel(frame: CGRectMake(0, -5, 0, 0))
        titleLabel.backgroundColor = UIColor.clearColor()
        titleLabel.textColor = UIColor.blackColor()
        titleLabel.font = UIFont.boldSystemFontOfSize(17)
        titleLabel.text = title
        titleLabel.sizeToFit()
        
        let subtitleLabel = UILabel(frame: CGRectMake(titleLabel.frame.size.width / 4, 18, 0, 0))
        subtitleLabel.backgroundColor = UIColor.clearColor()
        subtitleLabel.textColor = UIColor.lightGrayColor()
        subtitleLabel.font = UIFont.systemFontOfSize(12)
        subtitleLabel.text = subtitle
        subtitleLabel.sizeToFit()
        
        let titleView = UIView(frame: CGRectMake(0, 0, max(titleLabel.frame.size.width, subtitleLabel.frame.size.width), 30))
        titleView.addSubview(titleLabel)
        titleView.addSubview(subtitleLabel)
        
        
        return titleView
    }
    
    func differenceBetweenTimes(fromHour:String, fromMinute:String, toHour:String, toMinute:String, date:NSDate, pauze:Double) -> NSTimeInterval{
        let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        let fromComponents = calendar.components([.Day,.Hour,.Minute,.Month,.Year], fromDate: date)
        fromComponents.hour = Int(fromHour)!
        fromComponents.minute = Int(fromMinute)!
        let fromDate = calendar.dateFromComponents(fromComponents)
        
        let toComponents = calendar.components([.Day,.Hour,.Minute,.Month,.Year], fromDate: date)
        toComponents.hour = Int(toHour)!
        toComponents.minute = Int(toMinute)!-Int(pauze)
        let toDate = calendar.dateFromComponents(toComponents)
        return (toDate?.timeIntervalSinceDate(fromDate!))!
    }
    func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60)
    }
    
    func returnStartEndDate(fromHour:String, fromMinute:String, toHour:String, toMinute:String, date:NSDate) -> (startTime: NSDate, endTime: NSDate){
        let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        let fromComponents = calendar.components([.Day,.Hour,.Minute,.Month,.Year], fromDate: date)
        fromComponents.hour = Int(fromHour)!
        fromComponents.minute = Int(fromMinute)!
        let fromDate = calendar.dateFromComponents(fromComponents)
        
        let toComponents = calendar.components([.Day,.Hour,.Minute,.Month,.Year], fromDate: date)
        toComponents.hour = Int(toHour)!
        toComponents.minute = Int(toMinute)!
        let toDate = calendar.dateFromComponents(toComponents)
        return (fromDate!,toDate!)
    }
    func showAlertView(){
        let saveView: UIAlertController = UIAlertController(title: "Succes!", message: "Your times has been saved.", preferredStyle: .Alert)
        let cancelAction: UIAlertAction = UIAlertAction(title: "Okay", style: .Default) { action -> Void in
        }
        saveView.addAction(cancelAction)
        self.presentViewController(saveView, animated: true, completion: nil)
    }
    
    func showAlertDeleteView(context: NSManagedObjectContext, entityToDelete: String){
        let deleteView: UIAlertController = UIAlertController(title: "Delete", message: "Are you sure you would like to delete the data?", preferredStyle: .ActionSheet)
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel) {
            action -> Void in
            //let it go
        }
        deleteView.addAction(cancelAction)
        let deleteAction: UIAlertAction = UIAlertAction(title: "Delete", style: .Destructive){
            action -> Void in Hours.deleteEntity(context, objectDate: entityToDelete)
            
        }
        deleteView.addAction(deleteAction)
        self.presentViewController(deleteView, animated: true, completion: nil)
    }
    
    func searchResultArray(currentCellDate: String)-> NSInteger{
        var returnInt:Int = -1
        for i:Int in 0 ..< requested.count{
            let dateAsString = requested[i].dateAsString
            if (dateAsString! == currentCellDate){
                returnInt = i
                
            }
        }
        return returnInt
    }
    func showBreaks(startTime: Double, endTime:Double) -> Double{
        var breakTimes:Double = 0
        let returnValues = Break.getBreaks(startTime, endTime: endTime)
        let breaks = returnValues.0
        for x in 0 ..< breaks.count{
            if !breaks[x].isPayed() {
                breakTimes += Double(breaks[x].getMin())
            }
        }
        return breakTimes
    }

    
}
