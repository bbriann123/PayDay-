//
//  Settings.swift
//  PayDay!
//
//  Created by Brian van den Heuvel on 25/12/15.
//  Copyright © 2015 Brian van den Heuvel. All rights reserved.
//

import UIKit
import CoreData
import GoogleMobileAds
import MessageUI

class Settings: UIViewController, UITableViewDelegate, MFMailComposeViewControllerDelegate {
    let cellText = ["Uurloon", "Currency","Contract uren","Mail"]
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
    
    @IBOutlet weak var bannerView: GADBannerView!


    override func viewWillAppear(animated: Bool) {
        self.tableView.reloadData()
        let name = "Settings"
        let tracker = GAI.sharedInstance().trackerWithTrackingId("UA-73733245-2")
        tracker.set(kGAIScreenName, value: name)
        
        let builder = GAIDictionaryBuilder.createScreenView()
        tracker.send(builder.build() as [NSObject : AnyObject])
    }
  
    
    override func viewDidLoad(){
        super.viewDidLoad()
        bannerView.adUnitID = "ca-app-pub-1488852759580167/8897297931"
        bannerView.rootViewController = self
        bannerView.loadRequest(GADRequest())
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
        }else if indexPath.row == 3{
            if MFMailComposeViewController.canSendMail() {
                let mail = MFMailComposeViewController()
                mail.mailComposeDelegate = self
                mail.setToRecipients(["support.payday@mijnroadtrip.com"])
                mail.setSubject("PayDay! - App Contact")
                let message = "--<br>Device Version: \(UIDevice.currentDevice().modelName)"
                + "<br>OS name: \(UIDevice.currentDevice().systemName)"
                + "<br>iOS version: \(UIDevice.currentDevice().systemVersion)"
                + "<br> Device name: \(UIDevice.currentDevice().name)"
                + "<br> App version: \(UIApplication.versionBuild()))"
                print(UIApplication.appBuild())
                print(UIApplication.appVersion())
                
                mail.setMessageBody("<b><span style='color:grey'>My message</span></b><p> \(message)", isHTML: true)
                presentViewController(mail, animated: true, completion: nil)
            } else {
                // give feedback to the user
            }
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
    }
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        switch result.rawValue {
        case MFMailComposeResultCancelled.rawValue:
            print("Cancelled")
        case MFMailComposeResultSaved.rawValue:
            print("Saved")
        case MFMailComposeResultSent.rawValue:
            print("Sent")
        case MFMailComposeResultFailed.rawValue:
            print("Error: \(error?.localizedDescription)")
        default:
            break
        }
        controller.dismissViewControllerAnimated(true, completion: nil)
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
                    self.currentWage = Double(self.tField.text!.floatConverter)
                    }
                }else {
                    self.contractHours = Int(self.nextTextField.text!)!
                }
                savedSettings.insertSettings(self.currentWage, currency: self.getCurrency(), contractHours: self.getContractHours(), context: context)
                self.tableView.reloadData()}))
            //Fix for error with UICollectioNViewFlowLayOut    setting needs. See topic : <https://forums.developer.apple.com/thread/18294>
            alert.view.setNeedsLayout()
        }else if !accessoryButton{
            for size in 0...currencyArray.count{
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
extension String {
    var floatConverter: Float {
        let converter = NSNumberFormatter()
        converter.decimalSeparator = "."
        if let result = converter.numberFromString(self) {
            return result.floatValue
        } else {
            converter.decimalSeparator = ","
            if let result = converter.numberFromString(self) {
                return result.floatValue
            }
        }
        return 0
    }
}
extension UIDevice {
    
    var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8 where value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        switch identifier {
        case "iPod5,1":                                 return "iPod Touch 5"
        case "iPod7,1":                                 return "iPod Touch 6"
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
        case "iPhone4,1":                               return "iPhone 4s"
        case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
        case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
        case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
        case "iPhone7,2":                               return "iPhone 6"
        case "iPhone7,1":                               return "iPhone 6 Plus"
        case "iPhone8,1":                               return "iPhone 6s"
        case "iPhone8,2":                               return "iPhone 6s Plus"
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
        case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad 3"
        case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad 4"
        case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
        case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
        case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad Mini"
        case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"
        case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"
        case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"
        case "iPad6,7", "iPad6,8":                      return "iPad Pro"
        case "AppleTV5,3":                              return "Apple TV"
        case "i386", "x86_64":                          return "Simulator"
        default:                                        return identifier
        }
    }
    
}
extension UIApplication {
    
    class func appVersion() -> String {
        return NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleShortVersionString") as! String
    }
    
    class func appBuild() -> String {
        return NSBundle.mainBundle().objectForInfoDictionaryKey(kCFBundleVersionKey as String) as! String
    }
    
    class func versionBuild() -> String {
        let version = appVersion(), build = appBuild()
        
        return version == build ? "v\(version)" : "v\(version)(\(build))"
    }
}