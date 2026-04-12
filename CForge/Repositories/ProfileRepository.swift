//
//  ProfileRepository.swift
//  CForge
//
//  Created by Kartikey Chaudhary on 12/04/26.
//

// MARK: - ProfileRepository.swift
import Foundation

actor ProfileRepository {
    private let service: ProfileServiceProtocol
    
    private var cachedUser: CodeforcesUser?
    private var cachedSolvedCount: Int?
    private var cachedRatingHistory: [RatingChange]?
    
    init(service: ProfileServiceProtocol = ProfileService()) {
        self.service = service
    }
    
    func getProfile(handle: String) async throws -> CodeforcesUser {
        if let cached = cachedUser { return cached }
        
        let user = try await service.fetchProfile(handle: handle)
        self.cachedUser = user
        return user
    }
    
    func getSolvedProblemsCount(handle: String) async throws -> Int {
        if let cached = cachedSolvedCount { return cached }
        
        let count = try await service.fetchSolvedProblems(handle: handle)
        self.cachedSolvedCount = count
        return count
    }
    
    func getRatingHistory(handle: String) async throws -> [RatingChange] {
        if let cached = cachedRatingHistory { return cached }
        
        let history = try await service.fetchRatingHistory(handle: handle)
        self.cachedRatingHistory = history
        return history
    }
    
    func clearCache() {
        cachedUser = nil
        cachedSolvedCount = nil
        cachedRatingHistory = nil
    }
}
