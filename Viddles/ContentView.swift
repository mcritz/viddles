//
//  ContentView.swift
//  Viddles
//
//  Created by Michael Critz on 11/27/19.
//  Copyright © 2019 pixel.science. All rights reserved.
//

import SwiftUI
import Combine

struct ContentView: View {
    @Environment(\.managedObjectContext) var context
    @FetchRequest(fetchRequest: MealDay.getAllMealDays()) var mealDays: FetchedResults<MealDay>
    
    var body: some View {
        VStack {
            GeometryReader { geo in
                ScrollView {
                    Text("Days").font(.headline)
                    VStack {
                        ForEach(self.mealDays, id: \.self) { day in
                            HStack {
                                Text("day.description \(day.description)")
                                    .font(.largeTitle)
                                    .multilineTextAlignment(.center)
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
                print("hi")
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
