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
    @FetchRequest(fetchRequest: MealDay.allMealDayFetchRequest()) var mealDays: FetchedResults<MealDay>
    var body: some View {
        List(self.mealDays) { mealDay in
            Text("Day: \(mealDay.description)")
            
        }
    }
   /*
    var body: some View {
        VStack {
            GeometryReader { geo in
                ScrollView {
                    Text(self.mealDay.description).font(.headline)
                    VStack {
                        ForEach(self.mealDay.meals.allObjects as! [Meal], id: \.self) { meel in
                            HStack {
                                Text(meel.description)
                                    .font(.largeTitle)
                                    .multilineTextAlignment(.center)
                            }.onTapGesture {
//                                self.mealDay.vomit(meal: meel)
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
 */
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
