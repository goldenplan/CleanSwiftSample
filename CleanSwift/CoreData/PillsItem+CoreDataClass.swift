//
//  PillsItem+CoreDataClass.swift
//  CleanSwift
//
//  Created by Stanislav Belsky on 01.12.2019.
//  Copyright © 2019 Stanislav Belsky. All rights reserved.
//
//

import Foundation
import CoreData

@objc(PillsItem)
public class PillsItem: NSManagedObject {

    @discardableResult
    static func createOrUpdate(
        pillsData: PillsData,
        in context: NSManagedObjectContext) -> PillsItem?{
            
        let pillsItem = PillsItem.findOrCreate(pillsData: pillsData, in: context)
        
        if (pillsItem.desription != pillsData.desription ||
            pillsItem.dose != pillsData.dose ||
            pillsItem.img != pillsData.img ||
            pillsItem.name != pillsData.name){
            
            pillsItem.id = pillsData.id
            pillsItem.desription = pillsData.desription
            pillsItem.dose = pillsData.dose
            pillsItem.img = pillsData.img
            pillsItem.name = pillsData.name
            
            context.trySave()
        }
        
        return pillsItem
    }
    
    static func findOrCreate(
        pillsData: PillsData,
        in context: NSManagedObjectContext) -> PillsItem{
        
        let fetchRequest: NSFetchRequest<PillsItem> = PillsItem.fetchRequest()
        
        let pillByIdPredicate = NSPredicate(format: "id == \(pillsData.id)")
        
        fetchRequest.predicate = pillByIdPredicate
        
        if let pillsItems = try? context.fetch(fetchRequest),
           let pillsItem = pillsItems.first{
                return pillsItem
        } else {
            print("There was an error getting the results")
            return PillsItem(context: context)
        }
        
    }
    
    class func getFetchRequst(in context: NSManagedObjectContext)  -> NSFetchRequest<PillsItem>{
        
        let fetchRequest: NSFetchRequest<PillsItem> = PillsItem.fetchRequest()
        
        let newestSort = NSSortDescriptor(key:"id", ascending: true)
        
        fetchRequest.sortDescriptors = [newestSort]
        
        return fetchRequest
        
    }
    
    class func fetchPills(in context: NSManagedObjectContext) -> [PillsItem]{
        
        let fetchRequest = getFetchRequst(in: context)
        
        if let pills = try? context.fetch(fetchRequest) {
            return pills
        } else {
            print("There was an error getting the results")
            return []
        }
        
    }
    
    func getInnerDemoData() -> InnerDemoViewData{
        
        return InnerDemoViewData(
            objectId: objectID,
            title: name,
            description: dose)
        
    }
}
