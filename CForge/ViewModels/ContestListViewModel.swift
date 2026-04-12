//
//  ContestListViewModel.swift
//  CForge
//
//  Created by Harshit Raj on 12/04/26.
//

import Foundation

@MainActor
class ContestListViewModel: ObservableObject {
    enum ViewState {
        case idle, loading, loaded([CFContest]), error(String)
    }
    
    @Published var state: ViewState = .idle
    @Published var searchText: String = ""
    
    private let repository: ContestRepository
    private var allContests: [CFContest] = []
    
    init(repository: ContestRepository = ContestRepository()) {
        self.repository = repository
    }
    
    var filteredContests: [CFContest] {
        allContests
            .filter { searchText.isEmpty || $0.name.localizedCaseInsensitiveContains(searchText) }
            .sorted { $0.startTime < $1.startTime }
    }
    
    func loadContests(forceRefresh: Bool = false) async {
        if case .loading = state { return }
        
        state = .loading
        do {
            allContests = try await repository.getContests(forceRefresh: forceRefresh)
            state = .loaded(allContests)
        } catch {
            state = .error(error.localizedDescription)
        }
    }
}
