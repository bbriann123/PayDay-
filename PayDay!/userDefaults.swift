//
//  userDefaults.swift
//  PayDay!
//
//  Created by Brian van den Heuvel on 27/12/15.
//  Copyright © 2015 Brian van den Heuvel. All rights reserved.
//

import Foundation

class userDefaults{
    let preferences = NSUserDefaults.standardUserDefaults()
    func saveDefaultsDouble(key:String, name:Double){
        preferences.setDouble(name, forKey: key)
        let didSave:Bool = preferences.synchronize()
        if !didSave{
            print("ERROR!")
        }
    }
    
    func saveDefaultsString(key:String, name:String){
        preferences.setObject(name, forKey: key)
        print(name)
        let didSave:Bool = preferences.synchronize()
        if !didSave{
            print("ERROR!")
        }

    }
    
    
    func readDefaultsDouble(key:String) -> Double {
        if preferences.objectForKey(key) != nil {
            return preferences.doubleForKey(key)
        }else{
            return 0.0
        }
    }
    
    func readDefaultsString(key:String) -> String {
        if preferences.objectForKey(key) != nil {
            return preferences.stringForKey(key)!
        }else{
            return "Error reading stored data!"
        }
    }


}