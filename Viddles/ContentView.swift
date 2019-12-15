//
//  ContentView.swift
//  Viddles
//
//  Created by Michael Critz on 11/27/19.
//  Copyright © 2019 pixel.science. All rights reserved.
//

import SwiftUI
import Combine

struct Nom: Codable {
    let createdAt = Date()
    var nomValue: Int = 150
}

struct Meal: Identifiable, Hashable, Equatable, Codable, CustomStringConvertible {
    let type: MealType
    var id = UUID()
    var noms = [Nom]()
    var description: String {
        get {
            let allNomNoms = noms.reduce(into: "") { (res, _) in
                res.append("🍱")
            }
            return "\(type.description)\n\(allNomNoms)"
        }
    }
    
    static func == (lhs: Meal, rhs: Meal) -> Bool {
        lhs.id == rhs.id
    }
    
    mutating func vomit() {
        guard noms.count > 0 else { return }
        noms.removeLast()
    }
    
    mutating func eat(omNom: Nom) {
        noms.append(omNom)
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id.hashValue)
    }
    
    init(_ type: MealType) {
        self.type = type
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

class MealDay: Identifiable, ObservableObject, CustomStringConvertible {
    var description: String {
        get {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            return formatter.string(from: created)
        }
    }
    @Published var meals = [Meal]()
    let created: Date = Date()
    
    func vomit(meal: Meal) {
        guard let indx = self.meals.firstIndex(of: meal) else { return }
        var thisMeal = self.meals.remove(at: indx)
        thisMeal.vomit()
        if thisMeal.noms.count < 1 { return }
        self.meals.insert(thisMeal, at: indx)
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
        var existingMeal: Meal
        for meal in self.meals {
            if meal.type == type,
                let idx = self.meals.firstIndex(of: meal) {
                    existingMeal = meal
                    self.meals.remove(at: idx)
                    existingMeal.eat(omNom: Nom())
                    self.meals.insert(existingMeal, at: idx)
                    didEat = true
            }
        }
        if !didEat {
            var newMeal = Meal(type)
            newMeal.eat(omNom: Nom())
            self.meals.append(newMeal)
        }
    }
}

struct ContentView: View {
    @ObservedObject var mealDay = MealDay()
    
    var body: some View {
        VStack {
            ScrollView {
                Text(mealDay.description).font(.headline)
                VStack {
                    ForEach(mealDay.meals, id: \.self) { meel in
                        HStack {
                            Text(meel.description)
                                .font(.largeTitle)
                                .multilineTextAlignment(.center)
                        }.onTapGesture {
                            self.mealDay.vomit(meal: meel)
                        }
                    }
                }
            }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            Divider()
            Button(action: {
                self.mealDay.eat(nom: Nom())
            }) {
                Text("Nom")
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.green)
                    .cornerRadius(40)
                    .padding(.horizontal, 20.0)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
