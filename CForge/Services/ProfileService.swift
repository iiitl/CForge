//
//  ProfileService.swift
//  CForge
//
//  Created by Kartikey Chaudhary on 12/04/26.
//

// MARK: - ProfileService.swift
import Foundation

protocol ProfileServiceProtocol {
    func fetchProfile(handle: String) async throws -> CodeforcesUser
    func fetchSolvedProblems(handle: String) async throws -> Int
    func fetchRatingHistory(handle: String) async throws -> [RatingChange]
}

class ProfileService: ProfileServiceProtocol {
    
    func fetchProfile(handle: String) async throws -> CodeforcesUser {
        AppLog.debug("Fetching profile for: \(handle)")
        
        let urlString = "https://codeforces.com/api/user.info?handles=\(handle)"
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder().decode(CodeforcesResponse<[CodeforcesUser]>.self, from: data)
        
        guard let user = response.result.first else {
            throw URLError(.cannotParseResponse)
        }
        
        return user
    }
    
    func fetchSolvedProblems(handle: String) async throws -> Int {
        AppLog.debug("Fetching solved problems for: \(handle)")
        
        let urlString = "https://codeforces.com/api/user.status?handle=\(handle)"
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder().decode(CodeforcesResponse<[Submission]>.self, from: data)
        
        let solvedSubmissions = response.result.filter { $0.verdict == .ok }
        let uniqueProblems = Set(solvedSubmissions.map { $0.problem.name })
        
        return uniqueProblems.count
    }
    
    func fetchRatingHistory(handle: String) async throws -> [RatingChange] {
        AppLog.debug("Fetching rating history for: \(handle)")
        
        let urlString = "https://codeforces.com/api/user.rating?handle=\(handle)"
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder().decode(CodeforcesResponse<[RatingChange]>.self, from: data)
        
        return response.result
    }
}
