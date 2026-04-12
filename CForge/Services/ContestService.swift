import Foundation

protocol ContestServiceProtocol {
    func fetchContests() async throws -> [CFContest]
}

final class ContestService: ContestServiceProtocol {
    func fetchContests() async throws -> [CFContest] {
        guard let url = URL(string: "\(Constants.codeforcesBaseURL)contest.list") else {
            throw NetworkError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.transportError(wrapped: NSError(domain: "Invalid Response", code: 0))
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.serverError(statusCode: httpResponse.statusCode)
        }
        
        do {
            let decoded = try JSONDecoder().decode(CFContestResponse.self, from: data)
            guard decoded.status == "OK" else {
                throw NetworkError.apiError(message: decoded.comment ?? "Unknown API error")
            }
            return decoded.result?.filter { $0.phase == "BEFORE" } ?? []
        } catch {
            throw NetworkError.decodingError(wrapped: error)
        }
    }
}
