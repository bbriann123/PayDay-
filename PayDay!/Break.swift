//
//  Break.swift
//  PayDay!
//
//  Created by Brian van den Heuvel on 20/12/15.
//  Copyright © 2015 Brian van den Heuvel. All rights reserved.
//

import Foundation

class Break {
    enum BreakType {
        case Coffee
        case Breakfast
        case Lunch_half
        case Lunch_whole
        case Dinner
        
        
        func getMin() -> Int {
            switch self {
            case .Coffee: return 10
            case .Breakfast: return 15
            case .Lunch_half: return 30
            case .Lunch_whole: return 60
            case .Dinner:   return 30
            }
        }
        func isPayed() -> Bool {
            switch self {
            case .Coffee: return true
            default: return false
            }
            
        }
        func changeType() -> BreakType{
            //BreakType = .Dinner
            return Break.BreakType.Dinner
        }
    }
    
    static func getBreaks(startTime:Double, endTime:Double) -> ([BreakType], [Double]){
        var arrayList:Array <BreakType> = []
        var breakTime:Array <Double> = []
        var fictiveEndTime:Double = startTime+2
        var i:Int = -1
        var j:Int = -1
        var l:Int = 0
        var k:Int = 0
        repeat{
            if (endTime - fictiveEndTime < 2.0){
                break
            }else{
                //                print("false")
            }
            let break1 = getTypePauze(fictiveEndTime)
            let length1:Int = l + break1.getMin()
            var i1:Int = k;
            if !break1.isPayed(){
                i1 = k + break1.getMin()
            }
            var j1:Int = i;
            if (break1 == BreakType.Dinner){
                // CONTROLEER OF DIT GOED LOOPT!
                j1 = arrayList.count-1
            }
            var k1:Int = j;
            if (break1 == BreakType.Lunch_whole){
                k1 = arrayList.count
            }
            breakTime.append(fictiveEndTime)
            arrayList.append(break1)
            let fictiveEndTime2:Double = fictiveEndTime + 2
            l = length1
            i = j1
            j = k1
            k = i1
            fictiveEndTime = fictiveEndTime2
            if !break1.isPayed(){
                fictiveEndTime = fictiveEndTime2 + Double(break1.getMin())/60
                l = length1
                i = j1
                j = k1
                k = i1
            }
        }while (true)
        fictiveEndTime = endTime - startTime - Double(k)/60
        k = i

        if fictiveEndTime > 4.5 {
            k = i
            if endTime > 19{
                k = i
                if (i == -1){
                    arrayList.removeLast()
                    arrayList.append(BreakType.Dinner)
                    k = arrayList.count-1
                }
            }
        }
        if j >= 0 && (k >= 0 || endTime < 5.5){
            breakTime[breakTime.count-1] = breakTime[breakTime.count-1] - 0.5
            arrayList[j] = BreakType.Lunch_half
        }
        if fictiveEndTime > 5.5 && l < 30{
            breakTime.removeAll()
            breakTime.append(fictiveEndTime)
            arrayList.removeAll()
            arrayList.append(BreakType.Lunch_half)
        }
        print(fictiveEndTime)
        if( startTime == 9 && endTime >= 13 && endTime < 14){
            breakTime.removeAll()
            breakTime.append(fictiveEndTime)
            arrayList.removeAll()
            arrayList.append(BreakType.Coffee);
        }
        return (arrayList, breakTime)
    }
    
    
    static func getTypePauze(startTime:Double) -> BreakType{
        if startTime < 3{
            return BreakType.Coffee
        }
        if startTime < 5{
            return BreakType.Breakfast
        }
        if startTime < 7{
            return BreakType.Coffee
        }
        if startTime < 9{
            return BreakType.Breakfast
        }
        if startTime < 11{
            return BreakType.Coffee
        }
        if startTime < 14{
            return BreakType.Lunch_whole
        }
        if startTime < 17{
            return BreakType.Coffee
        }
        if startTime < 19{
            return BreakType.Dinner
        }else{
            return BreakType.Coffee
        }
    }
    
    
    
}
