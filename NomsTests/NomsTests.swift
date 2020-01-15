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
        // Put teardown code here. This method is called after the invocation of each test method in the class.
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
        let mealDay = MealDay.newDay(context: context)
        
        XCTAssertNotNil(mealDay.id)
        XCTAssertNotNil(mealDay.createdAt)
        XCTAssertNotNil(mealDay.description)
        XCTAssertNotNil(mealDay.meals)
        XCTAssertNotNil(mealDay.orderedMeals)
        XCTAssertEqual(mealDay.meals.count, 0)
        
        MealDay.eat(context, type: MealType.allTypes.randomElement()!, date: Date())
        
        let fetchRequest =  NSFetchRequest<MealDay>(entityName: "MealDay")
        let mealDays = try? context.fetch(fetchRequest)
        XCTAssertNotNil(mealDays)
        
    }

}
