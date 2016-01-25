//
//  savedSettings.swift
//  PayDay!
//
//  Created by Brian van den Heuvel on 14/01/16.
//  Copyright © 2016 Brian van den Heuvel. All rights reserved.
//
import Foundation
import CoreData

class savedSettings: NSManagedObject {
    
    //var results: [Hours]()
    //Inserts a new entity to the database.
    //All items are declared in Hours+CoreDataProperties.swift
    class func insertSettings(hourlyWage: Double, currency:String, contractHours:Int, context: NSManagedObjectContext) -> savedSettings?{
        let x = returnSettings(context)
        if x.count >= 1{
            updateSettings(hourlyWage,currency:currency,contractHours: contractHours,context:context)
        }else{
            let newSettings:savedSettings = NSEntityDescription.insertNewObjectForEntityForName("SavedSettings", inManagedObjectContext: context) as! savedSettings
            newSettings.hourlyWage = hourlyWage
            newSettings.currency = currency
            newSettings.contractHours = contractHours
            newSettings.uniqueKey = "oneAndOnly"
            do{
                try context.save()
            }catch let error as NSError{
                print("Save failed: \(error.localizedDescription)")
            }
            return newSettings
        }
        return nil
        
    }
    
    class func updateSettings(hourlyWage: Double, currency: String, contractHours: Int, context: NSManagedObjectContext){
        let key = "oneAndOnly"
        let predicate = NSPredicate(format: "uniqueKey == %@", key)
        let fetchrequest = NSFetchRequest(entityName: "SavedSettings")
        fetchrequest.predicate = predicate
        do {
            let fetchedEntities = try context.executeFetchRequest(fetchrequest) as! [savedSettings]
            fetchedEntities.first?.currency = currency
            fetchedEntities.first?.hourlyWage = hourlyWage
            fetchedEntities.first?.contractHours = contractHours
            try context.save()
        }catch let error as NSError {
            // failure
            print("Fetch failed: \(error.localizedDescription)")
        }
    }
    
    //Return all results.
    class func returnSettings(context: NSManagedObjectContext) -> [AnyObject]{
        var fetchResults:[AnyObject] = []
        let request = NSFetchRequest(entityName: "SavedSettings")
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