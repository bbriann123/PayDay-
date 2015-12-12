//
//  Hours+CoreDataProperties.swift
//  PayDay!
//
//  Created by Brian van den Heuvel on 9/28/15.
//  Copyright © 2015 Brian van den Heuvel. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Hours {

    @NSManaged var date: NSDate?
    @NSManaged var endTime: NSDate?
    @NSManaged var startTime: NSDate?
    @NSManaged var totalTime: NSNumber?
    @NSManaged var dateAsString: NSString?
    @NSManaged var periodeNumber: NSNumber?
    @NSManaged var yearNumber: NSNumber?
    @NSManaged var weekNumber: NSString?

}
