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
            ForEach(mealDay.meals, id: \.self) { meal in
                HStack(alignment: .top, spacing: 30) {
                    NomsView(meel: meal)
                }.padding()
            }
        }.background(Color.white)
    }
}

struct ContentView: View {
    @Environment(\.managedObjectContext) var context
    @FetchRequest(fetchRequest: MealDay.getAllMealDays()) var mealDays: FetchedResults<MealDay>
    
    func handleNomButton() {
        MealDay.eat(self.context)
    }
    
    var body: some View {
        ZStack {
            Color(hue: (42/360), saturation: 0.2, brightness: 0.99)
                .edgesIgnoringSafeArea(.all)
            VStack {
                Text("Noms")
                    .font(.largeTitle)
                    .foregroundColor(Color(hue: 0,
                                           saturation: 0.69,
                                           brightness: 0.79))
                Spacer()

                GeometryReader { geo in
                    ScrollView {
                        VStack {
                            ForEach(self.mealDays, id: \.id) { day in
                                VStack {
                                    VStack {
                                        Text(day.description)
                                            .font(.headline)
                                            .multilineTextAlignment(.center)
                                        MealDayDetailView(mealDay: day)
                                    }.padding()
                                    .background(Color.white)
                                    .cornerRadius(20)
                                    .frame(width: (geo.size.width - 40))
                                    
                                    Spacer()
                                }
                            }
                        }   .frame(width: geo.size.width, alignment: .top)
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
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
