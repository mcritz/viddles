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
    
    private let timer = NomTimer()
    
    // TODO: Find a better way to do this
    @State private var lastAteDescription: String = MealDay.lastAteDescription(context: (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext)
    
    init() {
        UITableView.appearance().separatorStyle = .none
        UITableView.appearance().backgroundColor = UIColor(named: "PrimaryBackground")
        UITableViewCell.appearance().backgroundColor = UIColor(named: "PrimaryBackground")
    }
    
    func handleNomButton() {
        MealDay.eat(self.context)
    }
    
    fileprivate func BigButton() -> some View {
        return HStack(alignment: .top, spacing: 20) {
            Button(action: {
                self.handleNomButton()
            }) {
                Text("Nom")
                    .font(.headline)
                    .bold()
                    .frame(minWidth: 180, idealWidth: 240, maxWidth: 320, minHeight: 50, idealHeight: 50, maxHeight: 50, alignment: .center)
                    .foregroundColor(Color(.label))
                    .background(
                        RadialGradient(gradient: Gradient(colors: [Color(.systemGreen), Color(.systemYellow)]),
                                       center: .center,
                                       startRadius: 0.0,
                                       endRadius: 800.0)
                    )
                    .cornerRadius(40)
            }.frame(minWidth: 150,
                    idealWidth: 320,
                    maxWidth: .infinity,
                    minHeight: 20,
                    idealHeight: 20,
                    maxHeight: 40,
                    alignment: .top)
            .animation(.interactiveSpring())
            Image("DropIcon", bundle: nil)
                .resizable()
                .frame(width: 50, height: 50, alignment: .bottomLeading)
                .onTapGesture {
                    print("hydro!")
                }
                .animation(.interactiveSpring())
        }
        .frame(minWidth: 320, idealWidth: 320, maxWidth: 480, minHeight: 50, idealHeight: 50, maxHeight: 50, alignment: .bottom)
        .padding([.horizontal], 20)
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
        ZStack(alignment: .bottom) {
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
                                .contextMenu {
                                    Button(action: {
                                        MealDay.eat(self.context,
                                                    type: .breakfast,
                                                    date: Nom.nominalDate(for: .breakfast,
                                                                          on: day.createdAt))
                                    }) {
                                        Text("Nom Breakfast")
                                    }
                                    Button(action: {
                                        MealDay.eat(self.context,
                                                    type: .lunch,
                                                    date: Nom.nominalDate(for: .lunch,
                                                                          on: day.createdAt))
                                    }) {
                                        Text("Nom Lunch")
                                    }
                                    Button(action: {
                                        MealDay.eat(self.context,
                                                    type: .dinner,
                                                    date: Nom.nominalDate(for: .dinner,
                                                                          on: day.createdAt))
                                    }) {
                                        Text("Nom Dinner")
                                    }
                                    Button(action: {
                                        MealDay.eat(self.context,
                                                    type: .snack,
                                                    date: Nom.nominalDate(for: .snack,
                                                                          on: day.createdAt))
                                    }) {
                                        Text("Nom Snack")
                                    }
                            }
                        }
                        .padding()
                        .background(Color(.systemBackground))
                        .cornerRadius(20)
                        .animation(.spring(response: 0.5,
                                           dampingFraction: 1.0,
                                           blendDuration: 0.75))
                    }
                    .foregroundColor(Color(.label))
                    .navigationBarTitle("Noms")
                    .foregroundColor(Color("PrimaryAccent"))
                    .navigationBarItems(trailing: notifcationPrefView())
                }
            }
            LinearGradient(gradient:
                Gradient(colors: [
                    Color("PrimaryTransparent"),
                    Color("PrimaryBackground")
                ]),
                           startPoint: .top,
                           endPoint: .bottom)
                .frame(height: 100).offset(x: 0, y: 40)
                .edgesIgnoringSafeArea(.all)
            BigButton()
                .offset(x: 0, y: -10)
            Text(lastAteDescription)
                .font(.headline)
                .bold()
                .offset(x: 0, y: -70)
                .onReceive(timer.timerPublisher) { _ in
                    self.lastAteDescription = MealDay.lastAteDescription(context: self.context)
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
