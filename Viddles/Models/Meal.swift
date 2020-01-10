//
//  Meal.swift
//  Viddles
//
//  Created by Michael Critz on 12/21/19.
//  Copyright © 2019 pixel.science. All rights reserved.
//

import CoreData

public class Meal: NSManagedObject {
    @NSManaged public var id: UUID
    @NSManaged public var type: String?
    @NSManaged public var createdAt: Date?
    @NSManaged public var noms: Set<Nom>
    @NSManaged public var mealDay: Set<MealDay>?
    
    override public var description: String {
        get {
            return self.type?.capitalized(with: Locale.current) ?? "Noms"
        }
    }
    
    var formattedDate: String {
        guard let createdAt = createdAt else { return "—" }
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: createdAt)
    }
}

extension Meal {
    static func getAllMeals() -> NSFetchRequest<Meal> {
        let request = Meal.fetchRequest() as! NSFetchRequest<Meal>
        let sorter = NSSortDescriptor(key: #keyPath(Meal.createdAt), ascending: false)
        request.sortDescriptors = [sorter]
        return request
    }
}

extension Meal {
    @objc(addNomsObject:)
    @NSManaged public func addToNoms(_ value: Nom)
    
    @objc(removeNomsObject:)
    @NSManaged public func removeFromNoms(_ value: Nom)
}

extension Meal {
    static func new(in context: NSManagedObjectContext, with nom: Nom?) -> Meal {
        let newMeal = Meal(context: context)
        newMeal.setValue(UUID(), forKey: #keyPath(Meal.id))
        newMeal.setValue(MealType.getCurrent().rawValue, forKey: #keyPath(Meal.type))
        newMeal.setValue(Date(), forKey: #keyPath(Meal.createdAt))
        if let realNom = nom {
            newMeal.addToNoms(realNom)
        }
        return newMeal
    }
    public func eat() {
        guard let context = self.managedObjectContext else { return }
        let newNom = Nom(context: context)
        newNom.setValue(150, forKey: #keyPath(Nom.value))
        newNom.setValue(self, forKey: #keyPath(Nom.meal))
        newNom.setValue(Date(), forKey: #keyPath(Nom.createdAt))
        self.addToNoms(newNom)
        try? context.save()
    }
    public func vomit() {
        guard let realNom = noms.randomElement() else { return }
        managedObjectContext?.delete(realNom)
        try? managedObjectContext?.save()

        if noms.count < 1 {
            let day = self.value(forKeyPath: #keyPath(Meal.mealDay)) as? MealDay
            day?.delete(meal: self)
        }
    }
}
