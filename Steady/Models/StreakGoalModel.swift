import Foundation
import SwiftData

/// Top-level item; represents a task that a user wants to build a streak for.
/// A goal is defined like this:
/// [start/stop/other] [action]
/// E.g. "Start exercising once every day"
@Model final class StreakGoalModel: Identifiable {
  let id: UUID = UUID()
  var type: StreakGoalType
  var name: String
  var datesPracticed: [Date]
  var achieved: Bool = false
  
  init(
    type: StreakGoalType = .start,
    name: String = "",
    datesPracticed: [Date] = [],
    achieved: Bool = false
  ) {
    self.type = type
    self.name = name
    self.datesPracticed = datesPracticed
    self.achieved = achieved
  }
}

/// Whether the goal is to do (start) or not to do (stop) a certain action regularly; i.e. build or break a habit
enum StreakGoalType: Codable {
  case start, stop, other
}

// MARK: - UnitProviding
extension StreakGoalModel: UnitProviding {
  static let unit = StreakGoalModel()
}
