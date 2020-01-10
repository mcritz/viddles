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
    @State var showingAlert = false
    
    var body: some View {
        HStack(alignment: .center, spacing: 20) {
            VStack(alignment: .leading) {
                Text(meel.description)
                    .font(.subheadline)
                Text(meel.formattedDate)
                    .font(.footnote)
                    .foregroundColor(.secondary)
            }
            .onTapGesture {
                self.meel.eat()
            }
            Spacer()
            HStack {
                if meel.noms.count > 4 {
                    Image("FatFaceOrange")
                } else {
                    ForEach(meel.noms, id: \.id) { nom in
                        Image(nom.type ?? Nom.randomType())
                    }
                }
            }
            .frame(minWidth: 100, idealWidth: 400, maxWidth: 550, alignment: .trailing)
            .onTapGesture {
                self.showingAlert.toggle()
            }
            .actionSheet(isPresented: self.$showingAlert) {
                ActionSheet(title: Text("Delete Nom?"),
                            buttons: [
                                .destructive(Text("Delete")) {
                                    self.meel.vomit()
                                },
                                .cancel()])
            }
        }
        .padding([.vertical])
    }
}
