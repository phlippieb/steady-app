import SwiftUI
import SwiftData

struct EditStreakGoal: View {
  @Binding var editingStreakGoal: StreakGoalModel??
  
  @Environment(\.modelContext) private var modelContext: ModelContext
  
  @State private var type = StreakGoalType.start
  @State private var name = ""
  @State private var achieved = false
  @State private var isDiscardAlertVisible = false
  @State private var isDeleteAlertVisible = false
  
  private enum FocusField {
    case name
  }
  
  @FocusState private var focusedField: FocusField?
  
  private var title: String {
    switch editingStreakGoal {
    case .some(.some): return "Edit Streak Goal"
    default: return "Add Streak Goal"
    }
  }
  
  private var isChanged: Bool {
    name != (editingStreakGoal??.name ?? "")
  }
  
  var body: some View {
    NavigationView {
      Form {
        Section {
          Picker("", selection: $type) {
            Text("Start").tag(StreakGoalType.start)
            Text("Stop").tag(StreakGoalType.stop)
            Text("Other").tag(StreakGoalType.other)
          }
          .pickerStyle(.segmented)
          
          TextField("Action", text: $name)
            .focused($focusedField, equals: .name)
            .submitLabel(.done)
        }
        
        if case .some(.some(_)) = editingStreakGoal {
          Section {
            Toggle(isOn: $achieved, label: {
              Text("Achieved")
            })
            
            Button(role: .destructive, action: onDeleteTapped) {
              HStack {
                Text("Delete")
                Spacer()
                Image(systemName: "trash")
              }
            }
            .alert(isPresented: $isDeleteAlertVisible) {
              Alert(
                title: Text("Delete this streak goal?"),
                primaryButton: .destructive(
                  Text("Delete"), action: onDeleteConfirmed),
                secondaryButton: .cancel())
            }
          }
        }
      }
      
      .onAppear {
        if case .some(.some(let streakGoal)) = editingStreakGoal {
          type = streakGoal.type
          name = streakGoal.name
          achieved = streakGoal.achieved
          
        } else {
          focusedField = .name
        }
      }
      
      .navigationTitle(title)
      .navigationBarTitleDisplayMode(.inline)
      
      .toolbar {
        ToolbarItem {
          Button(action: onSaveTapped) {
            Text("Save")
          }
          .disabled(isSaveDisabled)
        }
        
        ToolbarItem(placement: .navigation, content: {
          Button(action: onCancelTapped) { Text("Cancel") }
            .alert(isPresented: $isDiscardAlertVisible) {
              Alert(
                title: Text("Discard changes?"),
                primaryButton: .destructive(
                  Text("Discard"), action: onDiscardConfirmed),
                secondaryButton: .cancel())
            }
        })
        
      }
      
      .interactiveDismissDisabled(isChanged)
    }
  }
}

// MARK: Actions
private extension EditStreakGoal {
  func onSaveTapped() {
    switch editingStreakGoal {
    case .some(.none): saveNewStreakGoal()
    case .some(.some(let streak)): saveExistingStreakGoal(streak)
    case .none:break
    }
    
    editingStreakGoal = .none
  }
  
  private func saveNewStreakGoal() {
    let newStreak = StreakGoalModel(type: type, name: name, achieved: achieved)
    modelContext.insert(newStreak)
  }
  
  private func saveExistingStreakGoal(_ streakGoal: StreakGoalModel) {
    streakGoal.type = type
    streakGoal.name = name
    streakGoal.achieved = achieved
  }
  
  func onCancelTapped() {
    if isChanged {
      isDiscardAlertVisible = true
    } else {
      onDiscardConfirmed()
    }
  }
  
  func onDiscardConfirmed() {
    editingStreakGoal = nil
  }
  
  func onToggleAchievedTapped() {
    achieved.toggle()
  }
  
  func onDeleteTapped() {
    isDeleteAlertVisible = true
  }
  
  func onDeleteConfirmed() {
    if case .some(.some(let streak)) = editingStreakGoal {
      modelContext.delete(streak)
    }
    
    editingStreakGoal = nil
  }
}

// MARK: Validation
extension EditStreakGoal {
  var isSaveDisabled: Bool {
    isNameInvalid
  }
  
  var isNameInvalid: Bool {
    name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
  }
}

// MARK: Preview
#Preview {
  EditStreakGoal(editingStreakGoal: .constant(.some(.none)))
    .modelContainer(for: StreakGoalModel.self, inMemory: true)
}
