//
//  ProfileViewModel.swift
//  CForge
//
//  Created by Kartikey Chaudhary on 12/04/26.
//

// MARK: - ProfileViewModel.swift
import Foundation
import SwiftUI

enum ProfileViewState {
    case idle
    case loading
    case success(user: CodeforcesUser, solvedCount: Int, ratingHistory: [RatingChange])
    case error(message: String)
}

@MainActor
class ProfileViewModel: ObservableObject {
    @Published var state: ProfileViewState = .idle
    private let repository: ProfileRepository
    
    init(repository: ProfileRepository = ProfileRepository()) {
        self.repository = repository
    }
    
    func fetchAllProfileData(handle: String) {
        if case .success = state { return }
        
        state = .loading
        
        Task {
            do {
                let user = try await repository.getProfile(handle: handle)
                let count = try await repository.getSolvedProblemsCount(handle: handle)
                let history = try await repository.getRatingHistory(handle: handle)
                
                self.state = .success(user: user, solvedCount: count, ratingHistory: history)
                
            } catch {
                AppLog.error("Failed to load profile: \(error.localizedDescription)")
                self.state = .error(message: "Failed to load profile. Please try again.")
            }
        }
    }
    
    func handleLogout() async {
        await repository.clearCache()
        self.state = .idle
    }
}
