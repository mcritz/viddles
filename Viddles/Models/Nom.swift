//
//  Nom.swift
//  Viddles
//
//  Created by Michael Critz on 12/21/19.
//  Copyright © 2019 pixel.science. All rights reserved.
//

import CoreData

public class Nom: NSManagedObject, Identifiable {
    @NSManaged public var createdAt: Date?
    @NSManaged public var value: Int
}

extension Nom {
    static func getAllNoms() -> NSFetchRequest<Nom> {
        let request = Nom.fetchRequest() as! NSFetchRequest<Nom>
        let sorter = NSSortDescriptor(key: "createdAt", ascending: false)
        request.sortDescriptors = [sorter]
        return request
    }
}
