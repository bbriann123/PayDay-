//
//  Settings.swift
//  PayDay!
//
//  Created by Brian van den Heuvel on 25/12/15.
//  Copyright © 2015 Brian van den Heuvel. All rights reserved.
//

import UIKit
import CoreData

class Settings: UIViewController, UITableViewDelegate {
    let cellText = ["Uurloon", "Currency","Contract uren"]
    let currencyArray = ["€","$", "£","¥","CHF"]
    let currencyArrayString = ["EUR","USD","GBP","JPY","CHF"]
    var currencyNumber:Int = 0
    var currentWage:Double = 0
    var contractHours = 0
    var number = 0
    var tField: UITextField!
    var nextTextField: UITextField!
    var appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var navBar: UINavigationBar!
    override func viewDidLoad(){
        super.viewDidLoad()
        let context:NSManagedObjectContext = appDel.managedObjectContext
        navBar.topItem!.title = "Settings"
        var settings = savedSettings.returnSettings(context) as! [savedSettings]
        if !settings.isEmpty{
            contractHours = Int(settings[0].contractHours!)
            currentWage = Double(settings[0].hourlyWage!)
            switch (String(settings[0].currency!)){
            case String("€"):
                currencyNumber = 0;
            case "$":
                currencyNumber = 1;
            case "£":
                currencyNumber = 2;
            case "¥":
                currencyNumber = 3;
            case "CHF":
                currencyNumber = 4;
            default:
                currencyNumber = 0;
            }
        }

        
    }
    
    override func viewDidAppear(animated: Bool){
        self.tableView.reloadData()
        let context:NSManagedObjectContext = appDel.managedObjectContext
        var settings = savedSettings.returnSettings(context) as! [savedSettings]
        if !settings.isEmpty{
            contractHours = Int(settings[0].contractHours!)
            currentWage = Double(settings[0].hourlyWage!)
            switch (String(settings[0].currency!)){
            case String("€"):
                currencyNumber = 0;
            case "$":
                currencyNumber = 1;
            case "£":
                currencyNumber = 2;
            case "¥":
                currencyNumber = 3;
            case "CHF":
                currencyNumber = 4;
            default:
                currencyNumber = 0;
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        self.tableView.reloadData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(TableView: UITableView, numberOfRowsInSection section: Int)-> Int{
        return cellText.count
    }
    
    func tableView(TableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell:UITableViewCell = UITableViewCell(style:UITableViewCellStyle.Value1, reuseIdentifier: "settingsCell")
        cell.textLabel!.text = cellText[indexPath.row]
        if(indexPath.row == 0 || indexPath.row == 1 || indexPath.row == 2){
            if indexPath.row == 1 {
                cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
                cell.detailTextLabel!.text = "\(currencyArray[currencyNumber]) - \(currencyArrayString[currencyNumber])"
            }else if indexPath.row == 0{
                cell.accessoryType = UITableViewCellAccessoryType.DetailDisclosureButton
                cell.detailTextLabel!.text = "\(currencyArray[currencyNumber]) \(NSString(format: "%.2f", currentWage))"
            }else if indexPath.row == 2{
                cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
                cell.detailTextLabel!.text = String(getContractHours())
            }
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 0 {
            number = 1
            showAlert("Voer uurloon in", message: "", textField: true, styleAlert: true, accessoryButton: false)
        } else if indexPath.row == 1 {
            showAlert("Kies valuta", message:"Kies uw juiste valuta", textField: false, styleAlert: false, accessoryButton: false)
        }else if indexPath.row == 2 {
            number = 2
            showAlert("Voer contracturen in", message: "Per 4 weken", textField: true, styleAlert: true, accessoryButton: false)
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
    }

    func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 0 {
            showAlert("Uurloon", message: "Vul uw uurloon in om een goed beeld te krijgen van uw te verwachte loon.", textField: false, styleAlert: true,accessoryButton: true)
        }else if indexPath.row == 2{
            showAlert("Contract uren", message: "Vul uw contracturen in om een berekening te krijgen van uw loon.", textField: false, styleAlert: true,accessoryButton: true)
        }
    }
    
    func showAlert(title: String, message: String, textField: Bool, styleAlert:Bool, accessoryButton: Bool){
        let context:NSManagedObjectContext = appDel.managedObjectContext
        var alert = UIAlertController()
        if styleAlert {
            alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        }else{
            alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.ActionSheet)
        }
        if textField {
            alert.addTextFieldWithConfigurationHandler(configurationTextField)
            alert.addAction(UIAlertAction(title: "Done", style: UIAlertActionStyle.Default, handler: { (UIAlertAction)in
                if self.number == 1{
                    if ((self.tField.text?.isEmpty) != true){
                    self.currentWage = Double(self.tField.text!)!
                    }
                }else {
                    self.contractHours = Int(self.nextTextField.text!)!
                }
                savedSettings.insertSettings(self.currentWage, currency: self.getCurrency(), contractHours: self.getContractHours(), context: context)
                self.tableView.reloadData()}))
            //Fix for error with UICollectioNViewFlowLayOut    setting needs. See topic : <https://forums.developer.apple.com/thread/18294>
            alert.view.setNeedsLayout()
        }else if !accessoryButton{
            for var size = 0; size < currencyArray.count; ++size{
                let createdCurrency = "\(currencyArray[size]) - \(currencyArrayString[size])"
                alert.addAction(UIAlertAction(title: createdCurrency , style: UIAlertActionStyle.Default, handler : { (UIAlertAction)in
                    let currencySplit = UIAlertAction.title!.componentsSeparatedByString(" ")
                    if self.currencyArray.contains(currencySplit[0]){
                        self.currencyNumber = self.currencyArray.indexOf(currencySplit[0])!
                    }
                    savedSettings.insertSettings(self.currentWage, currency: self.getCurrency(), contractHours: self.getContractHours(), context: context)
                    self.tableView.reloadData()
                    alert.view.setNeedsLayout()
                }))
            }
        }
        alert.addAction(UIAlertAction(title: "Cancel", style:UIAlertActionStyle.Cancel, handler: nil ))
        let delay = 20 * Double(NSEC_PER_SEC)
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        dispatch_after(time,dispatch_get_main_queue()) { () -> Void in
            alert.dismissViewControllerAnimated(true, completion: nil)
        }
        self.presentViewController(alert, animated: true, completion: {})
        print(self.contractHours)
    }
    
    func getCurrency()-> String{
        return currencyArray[currencyNumber]
    }
    func getContractHours()-> Int{
        return contractHours
    }
    func configurationTextField(textField: UITextField!)
    {
        if number == 1{
            textField.placeholder = "Enter wage in format $.$$"
            textField.keyboardType = UIKeyboardType.DecimalPad
            tField = textField
        }else {
            textField.placeholder = "Enter contract hours"
            textField.keyboardType = UIKeyboardType.DecimalPad
            nextTextField = textField
        }
    }

}