//
//  Remmebers+CoreDataProperties.swift
//  RememberApp
//
//  Created by Alex Babich on 21.07.2020.
//  Copyright © 2020 alex-babich. All rights reserved.
//
//

import Foundation
import CoreData


extension Remmebers {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Remmebers> {
        return NSFetchRequest<Remmebers>(entityName: "Remmebers")
    }

    @NSManaged public var loved: Bool
    @NSManaged public var detail: String?
    @NSManaged public var favo: Int32
    @NSManaged public var imageD: Data?
    @NSManaged public var names: String?

}
