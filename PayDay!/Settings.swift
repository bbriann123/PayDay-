//
//  Settings.swift
//  PayDay!
//
//  Created by Brian van den Heuvel on 25/12/15.
//  Copyright © 2015 Brian van den Heuvel. All rights reserved.
//

import UIKit

class Settings: UIViewController, UITableViewDelegate {
    let cellText = ["Uurloon", "Currency"]
    let currencyArray = ["€","$", "£","¥","CHF"]
    let currencyArrayString = ["EUR","USD","GBP","JPY","CHF"]
    var currencyNumber:Int = 0
    var currentWage:Double = 0
    var tField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var navBar: UINavigationBar!
    override func viewDidLoad(){
        super.viewDidLoad()
        navBar.topItem!.title = "Settings"
        currentWage = userDefaults().readDefaultsDouble("currentWage")
        
    }
    
    override func viewDidAppear(animated: Bool){
        self.tableView.reloadData()
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
        if(indexPath.row == 0 || indexPath.row == 1){
            if indexPath.row == 1 {
                cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
                cell.detailTextLabel!.text = "\(currencyArray[currencyNumber]) - \(currencyArrayString[currencyNumber])"
            }else{
                cell.accessoryType = UITableViewCellAccessoryType.DetailDisclosureButton
                cell.detailTextLabel!.text = "\(currencyArray[currencyNumber]) \(NSString(format: "%.2f", currentWage))"
            }
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 0 {
            showAlert("Enter wage", message: "", textField: true, styleAlert: true, accessoryButton: false)
        } else if indexPath.row == 1 {
            showAlert("Choose currency", message:"Kies uw juiste valuta", textField: false, styleAlert: false, accessoryButton: false)
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
    }

    func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 0 {
            showAlert("Uurloon", message: "Vul uw uurloon in om een goed beeld te krijgen van uw te verwachte loon.", textField: false, styleAlert: true,accessoryButton: true)
        }
    }
    
    func showAlert(title: String, message: String, textField: Bool, styleAlert:Bool, accessoryButton: Bool){
        var alert = UIAlertController()
        if styleAlert {
            alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        }else{
            alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.ActionSheet)
        }
        if textField {
            alert.addTextFieldWithConfigurationHandler(configurationTextField)
            alert.addAction(UIAlertAction(title: "Cancel", style:UIAlertActionStyle.Destructive, handler:nil))
            alert.addAction(UIAlertAction(title: "Done", style: UIAlertActionStyle.Default, handler: { (UIAlertAction)in
                if ((self.tField.text?.isEmpty) != true){
                    self.currentWage = Double(self.tField.text!)!
                    userDefaults().saveDefaultsDouble("currentWage", name: Double(self.tField.text!)!)
                }
            
                self.tableView.reloadData()}))
            //Fix for error with UICollectioNViewFlowLayOut    setting needs. See topic : <https://forums.developer.apple.com/thread/18294>
            alert.view.setNeedsLayout()
        }else if !accessoryButton{
            for var size = 0; size < currencyArray.count-1; ++size{
                let createdCurrency = "\(currencyArray[size]) - \(currencyArrayString[size])"
                alert.addAction(UIAlertAction(title: createdCurrency , style: UIAlertActionStyle.Default, handler : { (UIAlertAction)in
                    let currencySplit = UIAlertAction.title!.componentsSeparatedByString(" ")
                    if self.currencyArray.contains(currencySplit[0]){
                        self.currencyNumber = self.currencyArray.indexOf(currencySplit[0])!
                        userDefaults().saveDefaultsString("currency", name: self.getCurrency())
                    }
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
        
        userDefaults().saveDefaultsString("currency", name: getCurrency())
        self.presentViewController(alert, animated: true, completion: {})
    }
    
    func getCurrency()-> String{
        return currencyArray[currencyNumber]
    }
    func configurationTextField(textField: UITextField!)
    {
        print("generating the TextField")
        textField.placeholder = "Enter wage in format $.$$"
        textField.keyboardType = UIKeyboardType.DecimalPad
        tField = textField
    }

}