//
//  ContestDetailView.swift
//  CForge
//
//  Created by Khushi Patil on 11/04/26.
//

import Foundation
import SwiftUI

struct ContestDetailView: View {
    let contest: CFContest

    var body: some View {
        VStack(spacing: 16) {
            Text(contest.name)
                .font(.title)

            Text("Phase: \(contest.phase)")
            Text("Type: \(contest.type)")
        }
        .padding()
    }
}
