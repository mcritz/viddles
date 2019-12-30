//
//  NomsView.swift
//  Viddles
//
//  Created by Michael Critz on 12/30/19.
//  Copyright © 2019 pixel.science. All rights reserved.
//

import SwiftUI
import Combine

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
                    [
                        Image("RoundFace"),
                        Image("BlueFace"),
                        Image("RedFace")
                    ].randomElement()
                }
            }.onTapGesture {
                self.meel.vomit()
            }
        }
    }
}
