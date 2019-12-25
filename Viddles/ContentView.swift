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
                    Text(["🍱", "🍎", "🍔", "🥩", "🍕", "🥗", "🌯", "🍜", "🍩"].randomElement()!)
                        .font(.largeTitle)
                }
            }
        }.onTapGesture {
            self.meel.vomit()
        }
    }
}


struct MealDayDetailView: View {
    @ObservedObject var mealDay: MealDay
    
    var body: some View {
        VStack {
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
        MealDay.eat(self.context)
    }
    
    var body: some View {
        VStack {
            GeometryReader { geo in
                ScrollView {
                    Text("Noms").font(.headline)
                    VStack {
                        ForEach(self.mealDays, id: \.id) { day in
                            VStack {
                                Text(day.description)
                                    .font(.subheadline)
                                    .multilineTextAlignment(.center)
                                MealDayDetailView(mealDay: day)
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
