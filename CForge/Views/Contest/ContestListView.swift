import SwiftUI

struct ContestListView: View {

    @State private var contests: [CFContest] = []
    @State private var selectedPhase = "Upcoming"
    @State private var selectedType = "All"
    @State private var ratedOnly = false
    @State private var isRefreshing = false
    @State private var showError = false
    @State private var errorMessage = ""
    @State private var searchText = ""

    private let phases = ["Upcoming", "Active", "Finished"]

    var body: some View {
        NavigationStack {
            VStack(spacing: 12) {

                Picker("Phase", selection: $selectedPhase) {
                    ForEach(phases, id: \.self) { Text($0) }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(["All", "CF", "ICPC", "IOI"], id: \.self) { type in
                            Button {
                                selectedType = type
                            } label: {
                                Text(type)
                                    .padding(8)
                                    .background(selectedType == type ? Color.blue : Color.gray.opacity(0.3))
                                    .cornerRadius(8)
                            }
                        }
                    }
                }

                ContestSearchBar(text: $searchText, placeholder: "Search contests...")
                    .padding(.horizontal)

                if isRefreshing {
                    ProgressView()
                } else {
                    ScrollView {
                        LazyVStack {
                            ForEach(filteredContests) { contest in
                                NavigationLink {
                                    ContestDetailView(contest: contest)
                                } label: {
                                    ContestCardView(contest: contest)
                                }
                            }
                        }
                    }
                    .refreshable {
                        await loadContests()
                    }
                }
            }
            .navigationTitle("Contests")

            .alert("Error", isPresented: $showError) {
                Button("OK") {}
            } message: {
                Text(errorMessage)
            }

            .onAppear {
                Task { await loadContests() }
            }
        }
    }

    var filteredContests: [CFContest] {
        contests.filter { contest in
            let matchesPhase =
                (selectedPhase == "Upcoming" && contest.phase == "BEFORE") ||
                (selectedPhase == "Active" && contest.phase == "CODING") ||
                (selectedPhase == "Finished" && contest.phase == "FINISHED")

            let matchesSearch =
                searchText.isEmpty ||
                contest.name.lowercased().contains(searchText.lowercased())

            return matchesPhase && matchesSearch
        }
    }

    // MARK: API

    func loadContests() async {
        isRefreshing = true
        do {
            contests = try await fetchContests()
        } catch {
            errorMessage = error.localizedDescription
            showError = true
        }
        isRefreshing = false
    }

    func fetchContests() async throws -> [CFContest] {
        let url = URL(string: "https://codeforces.com/api/contest.list")!
        let (data, _) = try await URLSession.shared.data(from: url)

        let response = try JSONDecoder().decode(ContestResponse.self, from: data)

        guard response.status == "OK" else {
            throw NSError(domain: "", code: 0)
        }

        return response.result ?? []
    }
    
    func handleError(_ error: Error) {
        errorMessage = error.localizedDescription
        showError = true
    }
}
