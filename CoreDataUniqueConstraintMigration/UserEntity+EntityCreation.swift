//
//  UserEntity+EntityCreation.swift
//  CoreDataUniqueConstraintMigration
//
//  Created by Naveen on 20/06/22.
//

import Foundation
import CoreData

extension UserEntity {

    public static func saveRecord(id: String?, name: String, age: Int32, context: NSManagedObjectContext) throws {
        let entity = NSEntityDescription.insertNewObject(forEntityName: "UserEntity", into: context) as! UserEntity
        entity.uniqueId = id
        entity.name = name
        entity.age = age
        context.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
        try context.saveToStore()
    }

}

extension NSManagedObjectContext {


    /// Saves the context and its parents if it has any. So that the change is propagated to the store
    ///
    /// - Throws: Any error thrown while saving the contexts
    public func saveToStore() throws {

        /// If there are not changes in teh context, we can just complete the stream
        guard hasChanges == true else {
            return
        }

        let saving = {
            try self.save()

            /// If there is a parent, call save again. But we have to make sure we wait till the parent is saved
            if self.parent != nil {
                try self.parent?.saveToStore()
            }
            else {
                return
            }
        }

        self.performAndWait {
            do {
                try saving()
            }
            catch let error {
                print("Failed to save context")
                print(error)
            }
        }
    }
}
