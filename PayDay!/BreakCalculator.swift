//
//  BreakCalculator.swift
//  PayDay!
//
//  Created by Brian van den Heuvel on 21/12/15.
//  Copyright © 2015 Brian van den Heuvel. All rights reserved.
//

import UIKit
import iAd
class BreakCalculator: UIViewController, UIPickerViewDelegate, ADBannerViewDelegate {

    
    @IBOutlet weak var outPut: UILabel!
    @IBOutlet weak var timePicker: UIPickerView!
    let hours:[String] = ["0","1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23"]
    let minutes:[String] = ["00","15","30","45"]
    var pickerViewRows = 10000
    var pickerViewMiddle = 0
   
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerViewMiddle = ((pickerViewRows / hours.count) / 2) * hours.count
        timePicker.selectRow(pickerViewMiddle + 7, inComponent: 0, animated: false)
        timePicker.selectRow(5008, inComponent: 3, animated: false)
        let startTime = Double(hours[timePicker.selectedRowInComponent(0) % hours.count] + "." + minutes[timePicker.selectedRowInComponent(1)])!
        let endTime = Double(hours[timePicker.selectedRowInComponent(3) % hours.count] + "." + minutes[timePicker.selectedRowInComponent(4)])!
        showBreaks(startTime, endTime: endTime)
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
            return 10_000
        }
        if(component == 2){
            return 1
        }
        return minutes.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0{
            return hours[row % hours.count]
        }else if component == 1{
            return minutes[row]
        }else if component == 2{
            return "-"
        }else if component == 3{
            return hours[row % hours.count]
        }
        
        return minutes[row]
        
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let hourOne = Int(hours[timePicker.selectedRowInComponent(0) % hours.count])!
        let hourTwo = Int(hours[timePicker.selectedRowInComponent(3) % hours.count])!
        let minutesOne = Int(minutes[timePicker.selectedRowInComponent(1)])!
        let minutesTwo = Int(minutes[timePicker.selectedRowInComponent(4)])!
        //Uptime
        if(component == 0 && hourOne > hourTwo){
            timePicker.selectRow(row, inComponent: (component + 3), animated: true)
            let newRow = pickerViewMiddle + (row % hours.count)
            pickerView.selectRow(newRow, inComponent: component, animated: false)
        }
        if (component == 1 && hourOne == hourTwo && minutesOne > minutesTwo){
            timePicker.selectRow(row, inComponent: (component + 3), animated: true)
        }
        //Downtime
        if(component == 3 && hourTwo < hourOne){
            timePicker.selectRow(row, inComponent: (component - 3), animated: true)
            let newRow = pickerViewMiddle + (row % hours.count)
            pickerView.selectRow(newRow, inComponent: component, animated: false)
        }
        if (component == 4 && hourOne == hourTwo && minutesTwo < minutesOne){
            timePicker.selectRow(row, inComponent: (component - 3), animated: true)
        }
        let startTime = Double(hours[timePicker.selectedRowInComponent(0) % hours.count] + "." + minutes[timePicker.selectedRowInComponent(1)])!
        let endTime = Double(hours[timePicker.selectedRowInComponent(3) % hours.count] + "." + minutes[timePicker.selectedRowInComponent(4)])!
        showBreaks(startTime, endTime: endTime)
    }
    
    
    func showBreaks(startTime: Double, endTime:Double){
        let returnValues = Break.getBreaks(startTime, endTime: endTime)
        let breaks = returnValues.0
        let breakTime = returnValues.1
        var totalString:String = ""
        for x in 0..<breaks.count{
            totalString = totalString + String(breaks[x].getMin()) + " minuten"
            if breaks[x].isPayed() {
                totalString += " betaalde"
            }else {
                totalString += " onbetaalde"
            }
            switch String(breaks[x]){
                case "Coffee": totalString += " koffie"
                case "Breakfast": totalString += " ontbijt"
                case "Lunch_half": totalString += " lunch"
                case "Lunch_whole": totalString += " lunch"
                case "Dinner": totalString += " diner"
                default: totalString += " ERROR"
            }
            totalString += NSString(format: "pauze om %.2f  uur \n", breakTime[x]) as String
        }
        outPut.text = totalString
    }


}