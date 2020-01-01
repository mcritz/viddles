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
    
    init() {
        UITableView.appearance().separatorStyle = .none
        UITableView.appearance().backgroundColor = UIColor(named: "PrimaryBackground")
        UITableViewCell.appearance().backgroundColor = UIColor(named: "PrimaryBackground")
    }
    
    func handleNomButton() {
        MealDay.eat(self.context)
    }
    
    fileprivate func BigButton() -> some View {
        return Button(action: {
            self.handleNomButton()
        }) {
            Text("Nom")
                .font(.headline)
                .bold()
                .frame(minWidth: 80, maxWidth: .infinity)
                .padding()
                .foregroundColor(Color(.label))
                .background(Color(.systemGreen))
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
        let nomReminderCntlr = NomReminderController()
        nomReminderCntlr.createReminders()
    }
    
    fileprivate func notifcationPrefView() -> some View {
        let imageName = "bell.fill"
        let image = Image(systemName: imageName).foregroundColor(Color("PrimaryAccent")).onTapGesture {            self.handleNotificationTap()
        }
        return image
    }
    
    var body: some View {
        ZStack {
            Color("PrimaryBackground")
                .edgesIgnoringSafeArea(.all)
            VStack {
                NavigationView {
                    List(self.mealDays, id:\.self) { day in
                        VStack {
                            Text(day.description)
                                .font(.headline)
                                .multilineTextAlignment(.center)
                            MealDayDetailView(mealDay: day)
                        }.padding()
                        .background(Color(.systemBackground))
                        .cornerRadius(20)
                    }.foregroundColor(Color(.label))
                    .navigationBarTitle("Noms")
                    .foregroundColor(Color("PrimaryAccent"))
                    .navigationBarItems(trailing: notifcationPrefView())
                }
                BigButton()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
