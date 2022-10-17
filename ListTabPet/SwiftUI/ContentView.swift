import SwiftUI

struct CellView: View {
    var data : (color: ElementColor, number: Int)
    var isHighlited: Bool
    var body: some View {
        HStack {
            Circle()
                .foregroundColor(colorForElement(data.color))
                .frame(width: 64, height: 64)
                .padding(17)
            Text(String(data.number))
            Spacer()
        }
        .background(isHighlited ? Color.lightBlue : .white)
        .ignoresSafeArea()
        .contentShape(Rectangle())
        .padding(.top, 1)
    }
}

struct ContentView: View {
    
    @ObservedObject var viewModel = ListViewModel(decisionProvider: RandomDecisionProvider())
    
    @State var highlitedCellIndex: Int? = nil
    
    init() {
        UIScrollView.appearance().bounces = false
    }
    
    var body: some View {
        VStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    ForEach(0..<viewModel.elementsTuples.count, id: \.self) {
                        index in
                        
                        CellView(data: viewModel.elementsTuples[index], isHighlited: index == highlitedCellIndex)
                            .onTapGesture {
                                highlitedCellIndex = index
                                viewModel.addValueOfAnElementBefore(index: index)
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                    if highlitedCellIndex == index {
                                        highlitedCellIndex = nil
                                    }
                                }
                            }
                        if index != viewModel.elementsTuples.count - 1 {
                            Divider()
                        }
                    }
                }
            }
            Spacer()
            Button(viewModel.isActiveTimer ? "Stop" : "Start"){
                viewModel.manageTimer()
            }
            .textCase(.uppercase)
            .font(.system(size: 20, weight: .medium, design: .default))
            .frame(maxWidth: .infinity)
            .frame(height: 65, alignment: .center)
            .foregroundColor(.white)
            .background(viewModel.isActiveTimer ? Color.customOrange : Color.customGreen)
            .cornerRadius(5)
            .padding(.horizontal, 17)
        }
    }
}

extension View {
    func colorForElement(_ elementColor: ElementColor) -> Color {
        switch elementColor {
        case .blue:
            return Color.customBlue
        case .orange:
            return Color.customOrange
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
