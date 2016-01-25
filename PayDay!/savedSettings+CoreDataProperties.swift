//
//  savedSettings+CoreDataProperties.swift
//  PayDay!
//
//  Created by Brian van den Heuvel on 14/01/16.
//  Copyright © 2016 Brian van den Heuvel. All rights reserved.
//

import Foundation
import CoreData

extension savedSettings {
    @NSManaged var hourlyWage: NSNumber?
    @NSManaged var currency: NSString?
    @NSManaged var contractHours: NSNumber?
    @NSManaged var uniqueKey: NSString?
    
}