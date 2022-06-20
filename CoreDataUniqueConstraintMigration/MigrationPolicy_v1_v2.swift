//
//  MigrationPolicy_v1_v2.swift
//  CoreDataUniqueConstraintMigration
//
//  Created by Naveen on 21/06/22.
//

import Foundation
import CoreData

class MigrationPolicy_v1_v2: NSEntityMigrationPolicy {

    override func begin(_ mapping: NSEntityMapping, with manager: NSMigrationManager) throws {
        //This will delete all the duplicate documents whose uniqueIdentifier is same
        let managedContext = manager.sourceContext
        let fetchRequest1 = UserEntity.fetchRequest()
        let result1: [NSManagedObject] = try managedContext.fetch(fetchRequest1)
        let uniqueIds = Set(result1.map { $0.value(forKeyPath: "uniqueId") as? String })
        for id in uniqueIds {
            let items = result1.filter({ $0.value(forKeyPath: "uniqueId") as? String == id })
            if items.count > 1 {
                //Not starting from 0th position as we need to keep one record
                for i in 1...(items.count - 1) {
                    managedContext.delete(items[i])
                }
            } else {
                continue
            }
        }
    }
}
