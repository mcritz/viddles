//
//  MealDayDetailView.swift
//  Viddles
//
//  Created by Michael Critz on 12/30/19.
//  Copyright © 2019 pixel.science. All rights reserved.
//

import SwiftUI
import Combine

struct MealDayDetailView: View {
    @ObservedObject var mealDay: MealDay
    
    var body: some View {
        VStack(alignment: .center) {
            ForEach(mealDay.orderedMeals, id: \.self) { meal in
                NomsView(meel: meal)
                    .animation(.linear(duration: 0.24))
            }
        }
    }
}
