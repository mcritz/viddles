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
    @NSManaged var meals: Set<Meal>
    
    override public var description: String {
        guard let realDate = createdAt else { return "—" }
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .full
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
    
    public var orderedMeals: [Meal] {
        get {
            return meals.sorted { (akok, esdf) -> Bool in
                if let comparison = akok.createdAt?.distance(to: esdf.createdAt!) {
                    return comparison > 0
                }
                return false
            }
        }
    }
    
    @objc(addToMealsObject:)
    @NSManaged public func addToMeals(_ value: Meal)
    
    @objc(removeFromMealsObject:)
    @NSManaged public func removeFromMeals(_ value: Meal)
}

extension MealDay {
    
    static func checkNewDay(context: NSManagedObjectContext) -> MealDay {
        let todaysMealDayFetchRequest = NSFetchRequest<MealDay>(entityName: "MealDay")
        
        let todayComponents = Calendar(identifier: .iso8601).dateComponents([.day, .month, .year], from: Date())
        let thisDay = Calendar(identifier: .iso8601).date(from: todayComponents)!
        
        let todaysMealDayPredicates = NSPredicate(format: "createdAt > %@", argumentArray: [thisDay])
        
        todaysMealDayFetchRequest.predicate = todaysMealDayPredicates
        do {
            let maybeMatchedDays = try context.fetch(todaysMealDayFetchRequest)
            if let matchedDay = maybeMatchedDays.first {
                return matchedDay
            }
        } catch {
            return MealDay.newDay(context: context)
        }
        return MealDay.newDay(context: context)
    }
    
    static func newDay(context: NSManagedObjectContext) -> MealDay {
        let newDay = MealDay(context: context)
        newDay.setValue(UUID(), forKey: #keyPath(MealDay.id))
        newDay.setValue(Date(), forKey: #keyPath(MealDay.createdAt))
        context.insert(newDay)
        try? context.save()
        return newDay
    }
    
    
    static func eat(_ context: NSManagedObjectContext) {
        
        let mealDay = MealDay.checkNewDay(context: context)
        
        let type = MealType.getCurrent()
        let currentMeal = mealDay.meals.filter{ meal -> Bool in
            return meal.type == type.rawValue
        }
        if let matchedMeal = currentMeal.first {
            matchedMeal.addToNoms(Nom.newNom(context: context))
        } else {
            let newMeal = Meal.new(in: context, with: Nom.newNom(context: context))
            newMeal.setValue(mealDay, forKey: #keyPath(Meal.mealDay))
            context.insert(newMeal)
        }
        try? context.save()
    }
}

extension MealDay {
    public func delete(meal: Meal) {
        guard let context = managedObjectContext else { return }
        context.delete(meal)
        try? context.save()
        if meals.count < 1 {
            context.delete(self)
            try? context.save()
        }
    }
}
