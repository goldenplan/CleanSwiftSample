//
//  PillsItem+CoreDataProperties.swift
//  CleanSwift
//
//  Created by Stanislav Belsky on 01.12.2019.
//  Copyright © 2019 Stanislav Belsky. All rights reserved.
//
//

import Foundation
import CoreData


extension PillsItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PillsItem> {
        return NSFetchRequest<PillsItem>(entityName: "PillsItem")
    }

    @NSManaged public var id: Int64
    @NSManaged public var name: String
    @NSManaged public var img: String
    @NSManaged public var desription: String
    @NSManaged public var dose: String

}
