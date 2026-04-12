//
//  ContestRepository.swift
//  CForge
//
//  Created by Harshit Raj on 12/04/26.
//

import Foundation

actor ContestRepository {
    private let service: ContestServiceProtocol
    private var cache: [CFContest]?
    private var lastFetch: Date?
    private let expirationInterval: TimeInterval = 300
    
    init (service: ContestServiceProtocol = ContestService()) {
        self.service = service
    }
    
    func getContests(forceRefresh: Bool) async throws -> [CFContest] {
        if !forceRefresh, let cache = cache, let lastFetch = lastFetch,
           Date().timeIntervalSince(lastFetch) < expirationInterval {
            AppLog.debug("ContestRepository: Returning cached data.", category: .cache)
            return cache
        }
        
        let contests = try await service.fetchContests()
        self.cache = contests
        self.lastFetch = Date()
        return contests
    }
}
