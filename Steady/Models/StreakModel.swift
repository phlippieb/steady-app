import Foundation

/// Represents a single streak in a goal; i.e. a continuous number of days practiced
struct StreakModel: Identifiable {
  let id: UUID = UUID()
  let startDate: Date
  var length: UInt
  var target: UInt
  
//  func status(on date: Date) throws -> StreakTodayStatus {
//    CalendarDate(date: .now)
//  }
}

/// A streak's status on a particular date
enum StreakStatus {
  /// The date is not a rest day and the user has not logged a practice yet
  case pendingPractice
  
  /// The date is not a rest day and the user has logged a practive
  case practiced
  
  /// The user has completed the streak on the previous day; the date is a rest day
  case rest
  
  /// The streak has ended some time in the past.
  /// - parameter successful: true if the user achieved to practive every day
  case ended(successful: Bool)
}

extension StreakGoalModel {
  /// Auto-compute all streaks from a streak goal's days practiced
  var streaks: [StreakModel] {
    guard let firstDatePracticed = datesPracticed.sorted().first else { return [] }
    
    var result: [StreakModel] = []
    var currentStreak: StreakModel?
    var currentTarget: UInt = 1
    
    for day in CalendarDate(date: firstDatePracticed) ... .today {
      if datesPracticed.contains(day.date) {
        if var currentStreak {
          // Extend the current streak
          currentStreak.length += 1
          
        } else {
          // Start a new streak
          currentStreak = StreakModel(
            startDate: day.date,
            length: 1,
            target: currentTarget)
        }
        
      } else if let s = currentStreak {
        // Streak has ended
        if s.length >= s.target {
          // Streak succeeded; increment target
          currentTarget += 1
        }
        
        // Add streak to results
        result.append(s)
        currentStreak = nil
      }
    }
    
    return result
  }
  
//  var currentStreak: StreakModel {
    // Note: not optional because it might make sense to just assume if no days practiced, then we're on the first streak day 1/1
//    .init(startDate: Date(), numberOfDays: 0)
    // ALTHOUGH
    // we need to be able to indicate these different things
    // - busy with a streak / on a rest day
    // - completed today / need to do today ( / on a rest day I guess)
    // but this might not be part of StreakModel but rather a sort of a today status?
//  }
}
