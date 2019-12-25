//
//  ContentView.swift
//  Viddles
//
//  Created by Michael Critz on 11/27/19.
//  Copyright © 2019 pixel.science. All rights reserved.
//

import SwiftUI
import Combine

extension Set: RandomAccessCollection {
    public func index(before i: Set<Element>.Index) -> Set<Element>.Index {
        return i
    }
}

struct NomsView: View {
    @ObservedObject var meel: Meal
    
    var body: some View {
        VStack {
            Text(meel.description)
            HStack {
                ForEach(meel.noms, id: \.id) { nom in
                    Text("🍱")
                }
            }
        }
    }
}


struct MealDayDetailView: View {
    @ObservedObject var mealDay: MealDay
    
    var body: some View {
        VStack {
            Text("Meals")
            ForEach(mealDay.meals, id: \.self) { meal in
                NomsView(meel: meal)
            }
        }
    }
}

struct ContentView: View {
    @Environment(\.managedObjectContext) var context
    @FetchRequest(fetchRequest: MealDay.getAllMealDays()) var mealDays: FetchedResults<MealDay>
    
    func handleNomButton() {
        let oldDay = mealDays.reduce(mealDays.last) { (prev, this) -> MealDay? in
            guard let thisDate = this.createdAt else { return nil }
            let difference = Calendar(identifier: .iso8601)
                           .dateComponents([Calendar.Component.day],
                                           from: Date(),
                                           to: thisDate)
            if difference.day == 0 {
                return this
            }
            return nil
        }
        if let realOldDay = oldDay {
            realOldDay.eat()
            return
        }
        let newMealDay = MealDay.newDay(context: context)
        newMealDay.eat()
        try? context.save()
    }
    
    var body: some View {
        VStack {
            GeometryReader { geo in
                ScrollView {
                    Text("Days").font(.headline)
                    VStack {
                        ForEach(self.mealDays, id: \.id) { day in
                            VStack {
                                Text(day.description)
                                    .font(.largeTitle)
                                    .multilineTextAlignment(.center)
                                MealDayDetailView(mealDay: day)
                            }.onTapGesture {
                                day.eat()
                                print("tap")
                            }
                        }
                    }.frame(width: geo.size.width,
                    alignment: .top)
                }
            }
            Divider()
            Button(action: {
                self.handleNomButton()
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
