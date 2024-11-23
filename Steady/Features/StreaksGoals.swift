import SwiftUI
import SwiftData

struct StreaksGoals: View {
  @Environment(\.modelContext) private var modelContext
  @Query private var streakGoals: [StreakGoalModel]
  
  @State private var editingStreak: StreakGoalModel??
  
  private var activeStreakGoals: [StreakGoalModel] {
    streakGoals.filter { !$0.achieved }
  }
  
  private var completedStreakGoals: [StreakGoalModel] {
    streakGoals.filter { $0.achieved }
  }
  
  var body: some View {
    NavigationStack {
      Group {
        if streakGoals.isEmpty {
          Text("No streaks yet")
            .foregroundStyle(.secondary)
          Button(action: addStreak) {
            Text("Add a streak")
          }
          
        } else {
          List {
            if !activeStreakGoals.isEmpty {
              Section {
                ForEach(activeStreakGoals) { item in
                  Button(action: { edit(item) }, label: {
                    StreakGoalItem(streakGoal: item)
                  })
                }
              } header: {
                Text("Active")
              }
            }
            
            if !completedStreakGoals.isEmpty {
              Section {
                ForEach(completedStreakGoals) { item in
                  Button(action: { edit(item) }, label: {
                    StreakGoalItem(streakGoal: item)
                  })
                }
              } header: {
                Text("Complete")
              }
            }
          }
        }
      }
      
      .navigationTitle("Streaks")
      .navigationBarTitleDisplayMode(.inline)
      
      .toolbar {
        ToolbarItem {
          Button(action: addStreak, label: {
            Text("Add")
          })
        }
      }
      
      .sheet(item: $editingStreak) { _ in
        EditStreakGoal(editingStreakGoal: $editingStreak)
      }
      
    }
  }
}

// MARK: - Actions

private extension StreaksGoals {
  func addStreak() {
    editingStreak = .some(.none)
  }
  
  func edit(_ item: StreakGoalModel) {
    editingStreak = .some(.some(item))
  }
}

// MARK: - Preview

#Preview {
  StreaksGoals()
    .modelContainer(for: StreakGoalModel.self, inMemory: true)
}
