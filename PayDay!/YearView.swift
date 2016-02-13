//
//  testFile.swift
//  PayDay!
//
//  Created by Brian van den Heuvel on 9/22/15.
//  Copyright © 2015 Brian van den Heuvel. All rights reserved.
//

import UIKit
import GoogleMobileAds

class YearView: UIViewController,UITableViewDelegate {
    
    
    var startDate:String = "2014-12-29" //yyyy-MM-dd
    var yearsArr = ["2015","2016","2017","2018","2019","2020"]
    var lastWeek = 0
    var varDec = VariableDec()
 
    @IBOutlet weak var TableView: UITableView!
    
    @IBOutlet weak var bannerView: GADBannerView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        bannerView.adUnitID = "ca-app-pub-1488852759580167/1395880731"
        bannerView.rootViewController = self
        bannerView.loadRequest(GADRequest())
        varDec = (tabBarController as! VariableController).varDec
        userDefaults().saveDefaultsDouble("currentWage", name:0.0)
    }
    
    override func viewDidAppear(animated: Bool) {
        //Do any additional setup when view is able to be seen
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return yearsArr.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell: UITableViewCell = UITableViewCell(style:UITableViewCellStyle.Subtitle, reuseIdentifier: "MyTestCell")
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        cell.textLabel!.text = yearsArr[indexPath.row]
        if (indexPath.row + 1) >= yearsArr.count {
            
            cell.detailTextLabel!.text = "\(yearsArr[indexPath.row]) - ..."
        } else{
            cell.detailTextLabel!.text = "\(yearsArr[indexPath.row]) - \(yearsArr[indexPath.row + 1])"
        }
        
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("testSegue", sender: nil)
        let currentCell = tableView.cellForRowAtIndexPath(indexPath)
        varDec.pressedYear = currentCell!.textLabel!.text!
    }
    
    
}
