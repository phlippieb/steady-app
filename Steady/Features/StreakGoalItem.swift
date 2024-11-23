import SwiftUI

struct StreakGoalItem: View {
  let streakGoal: StreakGoalModel
  
  private var typeText: String {
    switch streakGoal.type {
    case .start: return "Start"
    case .stop: return "Stop"
    case .other: return ""
    }
  }
  
  var body: some View {
    VStack(alignment: .leading) {
      HStack {
        Text(typeText).foregroundStyle(.secondary)
        Text(streakGoal.name)
      }
      .font(.headline)
      
      Spacer()
      
      Text("Current streak: 4/9")
      Text("Longest streak: 8")
      Text("Completed streaks: 2")
    }
    .padding()
  }
}

#Preview {
  let models: [StreakGoalModel] = [
    .init(type: .start, name: "Running"),
    .init(type: .stop, name: "Smoking"),
  ]
  
  return List {
    ForEach(models) { model in
      StreakGoalItem(streakGoal: model)
    }
  }
}
