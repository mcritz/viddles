//
//  MealEntryView.swift
//  Viddles
//
//  Created by Michael Critz on 3/23/23.
//  Copyright © 2023 pixel.science. All rights reserved.
//

import SwiftUI

struct MealEntryView: View {
    @State private var mealSize: Int = 0
    @State private var mealQuality: Int = 0
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Material.ultraThinMaterial)
            VStack(spacing: 16) {
                HStack {
                    Image(systemName: "fork.knife")
                    Text("Mealname")
                    Spacer()
                }
                .font(.headline)
                Picker("Size", selection: $mealSize) {
                    Button("Light") {
                        print("light")
                    }
                    .tag(0)
                    Button("Medium") {
                        print("medium")
                    }
                    .tag(1)
                    Button("Heavy") {
                        print("heavy")
                    }
                    .tag(2)
                }
                .pickerStyle(SegmentedPickerStyle())
                Picker("Quality", selection: $mealQuality) {
                    Button("Healthy") {
                        print("healthy")
                    }
                    .tag(0)
                    Button("Junky") {
                        print("junky")
                    }
                    .tag(1)
                }
                .pickerStyle(SegmentedPickerStyle())
            }
            .padding()
//                    VStack(alignment: .leading, spacing: 4) {
//                        Text("Today’s Total")
//                            .font(.caption)
//                            .bold()
//                        ChartView(chartModel)
//                    }
//                    .padding()
        }
    }
}

struct MealEntryView_Previews: PreviewProvider {
    static var previews: some View {
        MealEntryView()
    }
}
