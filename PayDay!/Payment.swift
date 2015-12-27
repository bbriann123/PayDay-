//
//  Payment.swift
//  PayDay!
//
//  Created by Brian van den Heuvel on 27/12/15.
//  Copyright © 2015 Brian van den Heuvel. All rights reserved.
//

import Foundation

class Payment {
    let contract = 12
    func getWorked(worked:Double) -> (allowance:Double, kptADV:Double, kptVacation:Double, kptADVWage:String, kptVacationWage:String, kptVacationAllowanceWage: String, kptWUKWage:String, kptGrossWage:String){
        var worked:Double = worked
        var allowance:Double = userDefaults().readDefaultsDouble("currentWage")
        var sick:Double = 0
        var bd:Double = 0
        allowance = floor(allowance * 4)/4
        let d:Double = worked// + allowance + sick + bd
        if contract <= 48{
            let d1:Double = d - Double(contract)
            if(d1 > 0 && contract != 0){
                let kptTVT = d1
                worked = worked-d1
            }
            let kptADV = 0.0901*d
            let kptVacation = 0.1109*d
            let kptVacationAllowance = 0.096100000000000005*d
            let kptWUK = 0.0327*d
            let kptGross = 1.3298000000000001*d
            let kptADVWage = NSString(format: "%.2f",(kptADV * allowance))
            let kptVacationWage = NSString(format: "%.2f",(kptVacation * allowance))
            let kptVacationAllowanceWage = NSString(format: "%.2f",(kptVacationAllowance * allowance))
            let kptWUKWage = NSString(format: "%.2f",(kptWUK * allowance))
            let kptGrossWage = NSString(format: "%.2f",(kptGross * allowance))
            return (allowance, kptADV, kptVacation, kptADVWage as String,kptVacationWage as String,kptVacationAllowanceWage as String ,kptWUKWage as String,kptGrossWage as String)
        }
        return (0.0,0.0,0.0,"","","","","")
    }
        
}