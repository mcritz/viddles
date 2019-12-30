//
//  ViddlesTests.swift
//  ViddlesTests
//
//  Created by Michael Critz on 11/27/19.
//  Copyright © 2019 pixel.science. All rights reserved.
//
    
import XCTest
import CoreData
@testable import Noms

class NomsTests: XCTestCase {
    
    var delegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func setUp() {
    }

    override func tearDown() {
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

}
