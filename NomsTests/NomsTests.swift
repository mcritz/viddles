//
//  NomsTests.swift
//  NomsTests
//
//  Created by Michael Critz on 1/9/20.
//  Copyright © 2020 pixel.science. All rights reserved.
//

import XCTest
import CoreData
@testable import Noms

class NomsTests: XCTestCase {
    
    var delegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testSetRandomAccess() {
        let set: Set<String> = ["Hello", "World"]
        XCTAssertNotNil(set.index(before: set.firstIndex(of: "World")!))
    }
    
    func testMealType() {
        let mealType = MealType.snack
        XCTAssertEqual(mealType.description, "Snack")
        
        let currentType = MealType.getCurrent()
        XCTAssertNotNil(currentType)
    }
    
    func testNom() {
        let context = delegate.persistentContainer.viewContext
        let nom = Nom.newNom(context: context)
        try? context.save()
        
        XCTAssertNotNil(nom.id)
        XCTAssertNotNil(nom.createdAt)
        XCTAssertNil(nom.meal)
        XCTAssertNotNil(nom.imageName)
        XCTAssertNotNil(nom.imageName())
        
        let getAllNomsFetchRequest = Nom.getAllNoms()
        XCTAssertNotNil(getAllNomsFetchRequest)
        let allNoms = try? context.fetch(getAllNomsFetchRequest)
        XCTAssertNotNil(allNoms)
        
        for type in MealType.allTypes {
            let someDate = Nom.nominalDate(for: type, on: Date())
            XCTAssertNotNil(someDate)
        }
    }
    
    func testImageName() {
        let omNom = Nom(context: delegate.persistentContainer.viewContext)
        let name = omNom.imageName()
        let image = UIImage(named: name)
        XCTAssertNotNil(image!)
    }
    
    func testNomFetchRequest() {
        let fetchRequest = Nom.fetchRequest()
        XCTAssertNotNil(fetchRequest)
    }
    
    func testMeal() {
        let context = delegate.persistentContainer.viewContext
        let meal = Meal.new(in: context, with: nil)
        try? context.save()
        
        let currentMealType = MealType.getCurrent()
        
        XCTAssertEqual(meal.type, currentMealType.rawValue)
        XCTAssertNotNil(meal.createdAt)
        XCTAssertNotNil(meal.description)
        XCTAssertEqual(meal.noms.count, 0)
        
        meal.eat()
        XCTAssertEqual(meal.noms.count, 1)
        
        let request: NSFetchRequest<Meal> = Meal.getAllMeals()
        let results = try? context.fetch(request)
        XCTAssertNotNil(results)
        
        meal.vomit()
        XCTAssertEqual(meal.noms.count, 0)
    }
    
    func testMealDay() {
        let context = delegate.persistentContainer.viewContext
        
        let getAllMealsFetchRequest = MealDay.getAllMealDays()
        do {
            let allMeals = try context.fetch(getAllMealsFetchRequest)
            allMeals.forEach {
                context.delete($0)
            }
        } catch {
            XCTFail("failed fetch request")
        }
        
        let neverAteDescription = MealDay.lastAte(context: context)
        XCTAssertNil(neverAteDescription)
        
        let mealDay = MealDay.newDay(context: context)
        
        XCTAssertNotNil(mealDay.id)
        XCTAssertNotNil(mealDay.createdAt)
        XCTAssertNotNil(mealDay.description)
        XCTAssertNotNil(mealDay.meals)
        XCTAssertNotNil(mealDay.orderedMeals)
        XCTAssertEqual(mealDay.meals.count, 0)
        
        let allMealDays = MealDay.getAllMealDays()
        XCTAssertNotNil(allMealDays)
        
        let mealDayForDate = MealDay.mealDay(context: context, for: Date())
        XCTAssertNotNil(mealDayForDate)
        
        
        MealDay.eat(context, type: MealType.allTypes.randomElement()!, date: Date())
        try? context.save()
        
        let fetchRequest =  NSFetchRequest<MealDay>(entityName: "MealDay")
        let mealDays = try? context.fetch(fetchRequest)
        XCTAssertNotNil(mealDays)
        
        
        let lastAteDescription = MealDay.lastAteDescription(context: context)
        XCTAssertNotNil(lastAteDescription)
    }

}
