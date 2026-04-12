import SwiftUI

enum ContestPhaseSelection: String, CaseIterable {
    case upcoming = "Upcoming"
    case active = "Active"
    case finished = "Finished"
    
    // Extracted shared constant for active phases
    static let activePhases = ["CODING", "PENDING_SYSTEM_TEST", "SYSTEM_TEST"]
}

enum ContestTypeSelection: String, CaseIterable {
    case all = "All"
    case cf = "CF"
    case icpc = "ICPC"
    case ioi = "IOI"
}

extension ContestListView {
    var filteredContests: [CFContest] {
        var result = contests
        
        if !searchText.isEmpty {
            result = result.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
        
        switch selectedPhase {
        case .upcoming:
            result = result.filter { $0.phase == "BEFORE" }
        case .active:
            // Replaced hardcoded array with the shared constant
            result = result.filter { ContestPhaseSelection.activePhases.contains($0.phase) }
        case .finished:
            result = result.filter { $0.phase == "FINISHED" }
        }
        
        if selectedType != .all {
            result = result.filter { $0.type.localizedCaseInsensitiveContains(selectedType.rawValue) }
        }
        
        if ratedOnly {
            result = result.filter { $0.isRated }
        }
        
        if selectedPhase == .finished {
            result.sort { $0.startTime > $1.startTime }
            result = Array(result.prefix(100))
        } else {
            result.sort { $0.startTime < $1.startTime }
        }
        
        return result
    }
}
