//
//  PillsService.swift
//  CleanSwift
//
//  Created by Stanislav Belsky on 01.12.2019.
//  Copyright © 2019 Stanislav Belsky. All rights reserved.
//

import Foundation
import CoreData

class PillsService {
    
    let pillsApi: PillsApi!
    
    init(pillsApi: PillsApi = PillsApi.shared) {
        self.pillsApi = pillsApi
    }
    
    func updatePills(context: NSManagedObjectContext){
        
        pillsApi.getList { (result) in
            
            switch result{
            case .success(let pills):
                
                pills.forEach {
                    PillsItem.createOrUpdate(
                        pillsData: $0, in: context)}
                break
            case .failure(let error):
                print("error", error)
            }
            
        }
        
    }
    
}
