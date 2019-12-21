import Foundation
import CoreData
import Combine

class Nom: NSManagedObject {
    let createdAt = Date()
    var nomValue: Int = 150
}

class Meal: NSManagedObject, Identifiable {
    let type: MealType = .snack
    let createdAt = Date()
    var id = UUID()
    let noms = mutableSetValue(forKey: "noms")
    override var description: String {
        get {
            let allNomNoms = noms.reduce(into: "") { (res, _) in
                res.append("🍱")
            }
            return "\(type.description)\n\(allNomNoms)"
        }
    }
    
    func vomit() {
        guard noms.count > 0 else { return }
        if let lastNom = noms.allObjects.last as? Nom {
            self.managedObjectContext?.delete(lastNom)
            try? self.managedObjectContext?.save()
            if noms.allObjects.count == 0 {
                self.managedObjectContext?.delete(self)
            }
        }
    }
    
    func eat(omNom: Nom) {
        omNom.setValue(self, forKey: "meal")
        try? self.managedObjectContext?.save()
    }
}

enum MealType: String, Codable, CustomStringConvertible {
    case snack, breakfast, lunch, dinner, midnight
    var description: String {
        get {
            return self.rawValue.capitalized(with: Locale.current)
        }
    }
}

class MealDay: NSManagedObject, Identifiable {
    
    static func allMealDayFetchRequest() -> NSFetchRequest<MealDay> {
        let request: NSFetchRequest<MealDay> = NSFetchRequest<MealDay>(entityName: "MealDay")
        request.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]
        return request
    }

    override var description: String {
        get {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            return formatter.string(from: createdAt)
        }
    }
    let createdAt: Date = Date()
    @Published var meals = mutableSetValue(forKey: "meals")
    
    
    func vomit(meal: Meal) {
        guard meals.contains(meal) else { return }
        let thisMeal = self.meals.allObjects.last as? Meal
        thisMeal?.vomit()
    }
    
    func eat(nom: Nom) {
        let hour = Calendar.current.component(.hour, from: Date())
        var type: MealType
        switch hour {
        case 1...5:
            type = .midnight
        case 6...9:
            type = .breakfast
        case 11...13:
            type = .lunch
        case 17...19:
            type = .dinner
        default:
            type = .snack
        }
        var didEat = false
        guard let allMeals = self.meals.allObjects as? [Meal],
            let context = self.managedObjectContext else {
                return
        }
        let matchedMeals = allMeals.filter{ $0.type == type }
        matchedMeals.forEach { (meal) in
            meal.eat(omNom: Nom(context: context))
            didEat = true
        }
        if !didEat {
            let newMeal = Meal(context: context)
            newMeal.eat(omNom: Nom())
            newMeal.setValue(self, forKey: "mealDay")
        }
    }
}
