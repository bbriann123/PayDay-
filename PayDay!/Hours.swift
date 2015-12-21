//
//  Hours.swift
//  PayDay!
//
//  Created by Brian van den Heuvel on 18/12/15.
//  Copyright © 2015 Brian van den Heuvel. All rights reserved.
//

import Foundation
import CoreData


class Hours: NSManagedObject {
    
    //var results: [Hours]()
    //Inserts a new entity to the database.
    //All items are declared in Hours+CoreDataProperties.swift
    class func insertTimes(date: NSDate, startTime:NSDate, endTime:NSDate,totalTime:Double, dateAsString: String, periodeNumber: Double, yearNumber: Double, weekNumber: String, context:NSManagedObjectContext) -> Hours{
        let newDate:Hours = NSEntityDescription.insertNewObjectForEntityForName("Hours", inManagedObjectContext: context) as! Hours
        newDate.date = date
        newDate.dateAsString = dateAsString
        newDate.startTime = startTime
        newDate.endTime = endTime
        newDate.yearNumber = yearNumber
        newDate.periodeNumber = periodeNumber
        newDate.totalTime = totalTime
        newDate.weekNumber = weekNumber
        do{
            try context.save()
        }catch let error as NSError{
            print("Save failed: \(error.localizedDescription)")
        }
        return newDate
        
    }
    
    //Return all results.
    class func returnDate(context: NSManagedObjectContext) -> [AnyObject]{
        var fetchResults:[AnyObject] = []
        let request = NSFetchRequest(entityName: "Hours")
        //request.returnsObjectsAsFaults = false
        do{
            fetchResults = try context.executeFetchRequest(request)
            //succes
        }catch let error as NSError {
            // failure
            print("Fetch failed: \(error.localizedDescription)")
        }
        
        return fetchResults
        
    }
    
    //Delete current result.
    class func deleteEntity(context: NSManagedObjectContext, objectDate: String){
        let predicate = NSPredicate(format: "dateAsString == %@", objectDate)
        
        let fetchRequest = NSFetchRequest(entityName: "Hours")
        fetchRequest.predicate = predicate
        do{
            let fetchedEntities = try context.executeFetchRequest(fetchRequest) as! [Hours]
            let entityToDelete = fetchedEntities.first
            context.deleteObject(entityToDelete!)
            
            try context.save()
        }catch let error as NSError {
            print("\(error)")
            
        }
    }
    
    
}

