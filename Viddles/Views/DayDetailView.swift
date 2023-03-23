import Combine
import SwiftUI

struct DayDetailView: View {
    
    var chartModel = ChartModel("Today’s Total", goal: 1.0)
    
    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView {
                VStack {
                    //                Image("RoundFaceLarge")
                    //                    .resizable()
                    //                    .aspectRatio(contentMode: .fit)
                    //                    .frame(minWidth: 50, idealWidth: 100, maxWidth: 150, minHeight: 50, idealHeight: 100, maxHeight: 150, alignment: .center)
                    MealEntryView()
                        .padding()
                    MealEntryView()
                        .padding()
                    MealEntryView()
                        .padding()
                }
                .shadow(radius: 44)
            }
            .background {
                Image("HealthyBackground")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .ignoresSafeArea()
            }
            ZStack(alignment: .bottom) {
//                LinearGradient(gradient: Gradient(colors: [.primary.opacity(0.7), .clear, .clear]),
//                               startPoint: .bottom,
//                               endPoint: .center)
                VStack(spacing: 16) {
                    
                    HStack(spacing: 16) {
                        Button {
                            print("add meal")
                        } label: {
                            ViewThatFits(in: .horizontal) {
                                HStack {
                                    Spacer()
                                    Image(systemName: "fork.knife")
                                    Text("Add meal")
                                        .font(.headline)
                                    Spacer()
                                }
                                .padding(.vertical, 4)
                                HStack {
                                    Image(systemName: "fork.knife")
                                    Text("Add")
                                        .font(.headline)
                                }
                                .padding(.vertical, 4)
                            }
                        }
                        .buttonStyle(BorderedProminentButtonStyle())
                        Button {
                            print("nom")
                            chartModel.increase(0.25)
                        } label: {
                            ViewThatFits(in: .horizontal) {
                                HStack {
                                    Image(systemName: "carrot.fill")
                                    Text("Snacks: 0")
                                        .font(.headline)
                                }
                                .padding(.vertical, 4)
                                HStack {
                                    Image(systemName: "carrot.fill")
                                    Text("0")
                                        .font(.headline)
                                }
                                .padding(.vertical, 4)
                            }
                        }
                        .buttonStyle(BorderedProminentButtonStyle())
                        Button {
                            chartModel.increase(0.25)
                            print("h20")
                        } label: {
                            ViewThatFits(in: .horizontal) {
                                HStack {
                                    Image(systemName: "drop.fill")
                                    Text("H₂O: 17")
                                        .font(.headline)
                                }
                                .padding(.vertical, 4)
                                HStack {
                                    Image(systemName: "drop.fill")
                                    Text("17")
                                        .font(.headline)
                                }
                                .padding(.vertical, 4)
                            }
                        }
                        .buttonStyle(BorderedProminentButtonStyle())
                    }
                }
                .padding()
            }
//            .buttonBorderShape(.roundedRectangle(radius: 40))
        }
    }
}

final public class ChartModel: ObservableObject {
    @Published var title: String = ""
    @Published var progress: Double = 0.0
    @Published var currentValue: Double = 0.0 {
        didSet {
            progress = currentValue / goalValue
        }
    }
    private var goalValue: Double = 1.0
    
    public init(_ title: String, _ current: Double = 0.0, goal: Double = 1.0) {
        self.title = title
        self.currentValue = current
    }
    
    func increase(_ ammount: Double = 0.25) {
        currentValue += ammount
    }
}

struct ChartView: View {
    
    @ObservedObject private var model: ChartModel
    
    func handleNom() {
        model.increase(0.25)
    }
    
    init(_ model: ChartModel) {
        self.model = model
    }
    
    @GestureState var isDetectingSwipe = false
    @State private var isDragging = false
    @State private var someX: CGFloat = 0.0
    @State private var someY: CGFloat = 0.0
    @State private var nomWidth: CGFloat = 24.0
    @State private var nomMaxWidth: CGFloat = 24.0
    @State private var viewWidth: CGFloat = 240.0
    
    private func update(_ point: CGPoint) {
        someX = point.x
        someY = point.y
        if someX >= 12
            && someX <= viewWidth {
            nomMaxWidth = someX + 12
        }
    }
    
    var body: some View {
        
        return ZStack(alignment: Alignment(horizontal: .leading, vertical: .center)) {
            GeometryReader(content: { geometry in
                RoundedRectangle(cornerRadius: 48)
                    .fill(Color.init(.displayP3, white: 0.85, opacity: 1.0))
                    .frame(minWidth: 240,
                           maxWidth: .infinity,
                           maxHeight: 24,
                           alignment: .center)
                    .onAppear {
                        viewWidth = geometry.size.width
                    }
                
                RoundedRectangle(cornerRadius: 48)
                    .fill(Color.red)
                    .frame(minWidth: 24,  maxWidth: nomMaxWidth, minHeight: 24, maxHeight: 24, alignment: .center)
            })
            .gesture(
                DragGesture(minimumDistance: 10, coordinateSpace: .local)
                    .onChanged({ someValue in
                        update(someValue.location)
                    })
            )
        
//            .overlay(
//                Circle()
//                    .fill(Color.blue)
//                    .frame(width: 20,
//                           height: 20,
//                           alignment: .center)
//                    .position(x: someX, y: someY)
//            )
        }
    }
}

struct DayDetailView_Previews: PreviewProvider {
    static var previews: some View {
        DayDetailView()
            .previewDevice("iPod touch (7th generation)")
    }
}
