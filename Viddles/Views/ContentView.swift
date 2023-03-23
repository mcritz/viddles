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
    @EnvironmentObject var reminderCntlr: NomReminderController
    
    // TODO: Find a better way to do this
    @State private var lastAteDescription: String = MealDay.lastAteDescription(context: (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext)
    
    fileprivate func BigButton() -> some View {
        return Button(action: {
            print("pressed nom")
        }) {
            Text("Nom")
                .font(.headline)
                .bold()
                .frame(minWidth: 80, maxWidth: .infinity)
                .padding()
                .foregroundColor(Color(.label))
                .background(
                    RadialGradient(gradient: Gradient(colors: [Color(.systemGreen), Color(.systemYellow)]),
                                   center: .center,
                                   startRadius: 0.0,
                                   endRadius: 800.0)
                )
                .cornerRadius(40)
                .padding(.horizontal, 20.0)
        }.frame(minWidth: 150,
                idealWidth: 320,
                maxWidth: .infinity,
                minHeight: 20,
                idealHeight: 20,
                maxHeight: 40,
                alignment: .top)
    }
    
    
    func handleNotificationTap() {
        reminderCntlr.toggleReminders()
    }
    
    fileprivate func notifcationPrefView() -> some View {
        let imageName = reminderCntlr.reminderStatus == .authorized ? "bell.fill" : "bell.slash.fill"
        let labelString = NSLocalizedString("Reminders", comment: "")
        
        return Button(action: {
            self.handleNotificationTap()
        }) {
            Image(systemName: imageName)
                .foregroundColor(Color("PrimaryAccent"))
                .scaledToFill()
            Text(labelString)
                .foregroundColor(Color("PrimaryAccent"))
        }
    }
    
    var body: some View {
        ZStack(alignment: .center) {
            Color("PrimaryBackground")
                .edgesIgnoringSafeArea(.all)
            DayDetailView(chartModel: .init("Today", goal: 1.0))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
