//
//  VariabeController.swift
//  PayDay!
//
//  Created by Brian van den Heuvel on 9/22/15.
//  Copyright © 2015 Brian van den Heuvel. All rights reserved.
//

import UIKit

class VariableController: UITabBarController {
    let varDec = VariableDec()
    
    override func viewDidLoad(){
        print("In VariableController")
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "NotificationAction:", name: "ShowView", object: nil)
        
    }
    
    func NotificationAction(notification: NSNotification){
        print("in variableController")
        print(notification)
        print(notification.userInfo!["aps"]!)
        dispatch_async(dispatch_get_main_queue()){
            UITabBarController().selectedIndex = 3
        }
    }
}