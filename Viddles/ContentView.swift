//
//  ContentView.swift
//  Viddles
//
//  Created by Michael Critz on 11/27/19.
//  Copyright © 2019 pixel.science. All rights reserved.
//

import SwiftUI

struct Meal: Identifiable, Hashable {
    var id = UUID()
    var name = "Meal"
    var noms = "👄👄👄👄"
}

struct ContentView: View {
    @State var meals = [
        Meal(name: "Breakfast", noms: "👄"),
        Meal(name: "Lunch", noms: "👄👄👄"),
        Meal(name: "Snack", noms: "👄👄")
    ]
    var body: some View {
        VStack {
            Text("Face")
            VStack {
                ForEach(meals, id: \.self) { meel in
                    HStack {
                        Text(meel.name)
                        Text(meel.noms)
                    }
                }
            }
            VStack {
                Button(action: {
                    self.meals.append(Meal(name: "Snack", noms: "👄"))
                }) {
                    Text("Nom")
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
