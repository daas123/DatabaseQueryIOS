//
//  UserEvent+CoreDataProperties.swift
//  DatabaseQuery
//
//  Created by Neosoft on 05/12/23.
//
//

import Foundation
import CoreData


extension UserEvent {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserEvent> {
        return NSFetchRequest<UserEvent>(entityName: "UserEvent")
    }

    @NSManaged public var desc: String?
    @NSManaged public var date: String?
    @NSManaged public var title: String?

}

extension UserEvent : Identifiable {

}
