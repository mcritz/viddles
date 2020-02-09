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
            return meals.sorted {
                if let comparison = $0.createdAt?.distance(to: $1.createdAt!) {
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
    
    static func mealDay(context: NSManagedObjectContext, for date: Date = Date()) -> MealDay {
        let todaysMealDayFetchRequest = NSFetchRequest<MealDay>(entityName: "MealDay")
        
        let todayComponents = Calendar(identifier: .iso8601).dateComponents([.day, .month, .year], from: date)
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
    
    
    static func eat(_ context: NSManagedObjectContext,
                         type: MealType = MealType.getCurrent(),
                         date: Date = Date()) {
        
        let mealDay = MealDay.mealDay(context: context, for: date)
        let currentMeal = mealDay.meals.filter{ meal -> Bool in
            return meal.type == type.rawValue
        }
        if let matchedMeal = currentMeal.first {
            matchedMeal.addToNoms(Nom.newNom(context: context, date: date))
        } else {
            let newMeal = Meal(context: context)
            newMeal.setValue(UUID(), forKey: #keyPath(Meal.id))
            newMeal.setValue(type.rawValue, forKey: #keyPath(Meal.type))
            newMeal.setValue(mealDay, forKey: #keyPath(Meal.mealDay))
            newMeal.setValue(date, forKey: #keyPath(Meal.createdAt))
            newMeal.addToNoms(Nom.newNom(context: context, date: date))
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


extension MealDay {
    
    static func lastAteDescription(context: NSManagedObjectContext) -> String {
        guard let lastAteMeal = MealDay.lastAte(context: context),
            let lastAteDate = lastAteMeal.createdAt else {
                return ""
        }
        let relativeDescriptiveTime = NomTimer().timeSince(date: lastAteDate)
        
        if lastAteDate > Date() {
            return "\(lastAteMeal.description) \(relativeDescriptiveTime)"
        }
        
        if relativeDescriptiveTime.count == 0 {
            return "Having \(lastAteMeal.description) right now"
        }
        return "\(relativeDescriptiveTime)since \(lastAteMeal.description)"
    }
    
    static func lastAte(context: NSManagedObjectContext) -> Meal? {
        let request = MealDay.fetchRequest() as! NSFetchRequest<MealDay>
        let sorter = NSSortDescriptor(key: #keyPath(MealDay.createdAt), ascending: false)
        request.sortDescriptors = [sorter]
        request.fetchLimit = 1
        do {
            let lastMealDay = try context.fetch(request).first
            let lastMealOfLastMealDay = lastMealDay?.meals.sorted(by: {
                if let comparison = $0.createdAt?.distance(to: $1.createdAt!) {
                    return comparison < 0
                }
                return false
            }).first
            return lastMealOfLastMealDay
        } catch {
            print("couldn’t fetch just one")
        }
        return nil
    }
}
