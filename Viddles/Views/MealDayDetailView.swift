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
                    .animation(.spring(response: 0.5,
                        dampingFraction: 1.0,
                        blendDuration: 0.75))
            }
        }
    }
}
