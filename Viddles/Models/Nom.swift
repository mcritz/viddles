//
//  Nom.swift
//  Viddles
//
//  Created by Michael Critz on 12/21/19.
//  Copyright © 2019 pixel.science. All rights reserved.
//

import CoreData

public class Nom: NSManagedObject {
    @NSManaged public var id: UUID?
    @NSManaged public var createdAt: Date?
    @NSManaged public var value: Int
    @NSManaged public var type : String?
    @NSManaged public var meal: Set<Meal>?
}

extension Nom {
    static func getAllNoms() -> NSFetchRequest<Nom> {
        let request = Nom.fetchRequest() as! NSFetchRequest<Nom>
        let sorter = NSSortDescriptor(key: #keyPath(Nom.createdAt), ascending: false)
        request.sortDescriptors = [sorter]
        return request
    }
    
    static func newNom(context: NSManagedObjectContext) -> Nom {
        let newNom = Nom(context: context)
        newNom.setValue(UUID(), forKey: #keyPath(Nom.id))
        newNom.setValue(Date(), forKey: #keyPath(Nom.createdAt))
        newNom.setValue(150, forKey: #keyPath(Nom.value))
        newNom.setValue(Nom.randomType(), forKey: #keyPath(Nom.type))
        return newNom
    }
    
    static func randomType() -> String {
        return [
            "RoundFace",
            "BlueFace",
            "RedFace",
            "GreenFace"
            ].randomElement()!
    }
}

extension Nom {
    
    func imageName() -> String {
        guard let name = self.type else {
            return "RoundFace"
        }
        return name
    }
}
