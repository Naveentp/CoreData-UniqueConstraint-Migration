//
//  UserEntity+CoreDataProperties.swift
//  CoreDataUniqueConstraintMigration
//
//  Created by Naveen on 20/06/22.
//
//

import Foundation
import CoreData


extension UserEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserEntity> {
        return NSFetchRequest<UserEntity>(entityName: "UserEntity")
    }

    @NSManaged public var uniqueId: String?
    @NSManaged public var name: String?
    @NSManaged public var age: Int32

}

extension UserEntity : Identifiable {

}
