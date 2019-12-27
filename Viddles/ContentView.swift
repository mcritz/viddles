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
        HStack(alignment: .firstTextBaseline, spacing: 20) {
            Text(meel.description)
                .font(.subheadline)
                .onTapGesture {
                    self.meel.eat()
                }
            Spacer()
            HStack {
                ForEach(meel.noms, id: \.id) { nom in
                    Text(["🍱", "🍎", "🍔", "🥩", "🍕", "🥗", "🌯", "🍜", "🍩"].randomElement()!)
                        .font(.largeTitle)
                }
            }.onTapGesture {
                self.meel.vomit()
            }
        }
    }
}


struct MealDayDetailView: View {
    @ObservedObject var mealDay: MealDay
    
    var body: some View {
        VStack(alignment: .center) {
            ForEach(mealDay.orderedMeals, id: \.self) { meal in
                HStack(alignment: .top, spacing: 30) {
                    NomsView(meel: meal)
                }.padding()
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
    
    fileprivate func BigButton() -> some View {
        return Button(action: {
            self.handleNomButton()
        }) {
            Text("Nom")
                .font(.headline)
                .frame(minWidth: 80, maxWidth: .infinity)
                .padding()
                .foregroundColor(Color(.label))
                .background(Color(.systemGreen))
                .cornerRadius(40)
                .padding(.horizontal, 20.0)
        }.frame(minWidth: 150, idealWidth: 320, maxWidth: .infinity, minHeight: 20, idealHeight: 20, maxHeight: 40, alignment: .top)
    }
    
    var body: some View {
        ZStack {
            Color("PrimayBackground")
                .edgesIgnoringSafeArea(.all)
            VStack {
                NavigationView {
                    List {
                        ForEach(self.mealDays, id: \.id) { day in
                            VStack {
                                Text(day.description)
                                    .font(.headline)
                                    .multilineTextAlignment(.center)
                                MealDayDetailView(mealDay: day)
                            }.padding()
                            .background(Color(.systemBackground))
                            .cornerRadius(20)
                        }
                    }.navigationBarTitle("Noms")
                }
                BigButton()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
