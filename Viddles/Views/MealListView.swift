//
//  MealListView.swift
//  Viddles
//
//  Created by Michael Critz on 7/31/22.
//  Copyright © 2022 pixel.science. All rights reserved.
//

import SwiftUI

struct MealListView: View {
    @Environment(\.managedObjectContext) var context
    @FetchRequest(fetchRequest: MealDay.getAllMealDays()) var mealDays: FetchedResults<MealDay>
    var body: some View {
        Text("Hello, World!")
    }
}

struct MealListView_Previews: PreviewProvider {
    static var previews: some View {
        MealListView()
    }
}
