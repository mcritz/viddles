//
//  MealDay.swift
//  Viddles
//
//  Created by Michael Critz on 12/22/19.
//  Copyright © 2019 pixel.science. All rights reserved.
//

import CoreData

public class MealDay: NSManagedObject {
    @NSManaged var id: UUID?
    @NSManaged var createdAt: Date?
    @NSManaged var meals: Set<Meal>?
    
    override public var description: String {
        guard let realDate = createdAt else { return "—" }
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        return dateFormatter.string(from: realDate)
    }
}

extension MealDay {
    static func getAllMealDays() -> NSFetchRequest<MealDay> {
        let request = MealDay.fetchRequest() as! NSFetchRequest<MealDay>
        let sorter = NSSortDescriptor(key: #keyPath(MealDay.createdAt), ascending: false)
        request.sortDescriptors = [sorter]
        return request
    }
    
    @objc(addToMealsObject:)
    @NSManaged public func addToMeals(_ value: Meal)
    
    @objc(removeFromMealsObject:)
    @NSManaged public func removeFromMeals(_ value: Meal)
}

extension MealDay {
    static func newDay(context: NSManagedObjectContext) {
        let newDay = MealDay(context: context)
        newDay.setValue(UUID(), forKey: #keyPath(MealDay.id))
        newDay.setValue(Date(), forKey: #keyPath(MealDay.createdAt))
        context.insert(newDay)
        try? context.save()
    }
    
    
    public func eat() {
        
        guard let context = self.managedObjectContext else { return }
        
        let type = MealType.getCurrent()
        let currentMeal = meals?.filter{ meal -> Bool in
            return meal.type == type.rawValue
        }
        if let matchedMeal = currentMeal?.first {
            matchedMeal.addToNoms(Nom.newNom(context: context))
        } else {
            let newMeal = Meal.new(in: context, with: Nom.newNom(context: context))
            newMeal.setValue(self, forKey: #keyPath(Meal.mealDay))
            context.insert(newMeal)
            try? context.save()
        }
        try? self.managedObjectContext?.save()
    }
}
