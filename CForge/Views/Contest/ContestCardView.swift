//
//  ContestCardView.swift
//  CForge
//
//  Created by Khushi Patil on 11/04/26.
//

import SwiftUI

struct ContestCardView: View {
    let contest: CFContest
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            
            // Title
            Text(contest.name)
                .font(.headline)
                .foregroundColor(.white)
            
            // Time + Duration row
            HStack(spacing: 16) {
                
                Label {
                    Text(contest.timeUntilStart)
                } icon: {
                    Image(systemName: "clock")
                }
                
                Label {
                    Text(contest.duration)
                } icon: {
                    Image(systemName: "hourglass")
                }
                
                Spacer()
                
                // Register Button
                if let url = contest.registrationUrl {
                    Link("Register", destination: url)
                        .font(.subheadline)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.blue.opacity(0.2))
                        .cornerRadius(8)
                }
            }
            .font(.caption)
            .foregroundColor(.cyan)
        }
        .padding()
        .background(
            LinearGradient(
                colors: [Color.black.opacity(0.9), Color.gray.opacity(0.2)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.cyan.opacity(0.5), lineWidth: 1)
        )
        .cornerRadius(16)
        .padding(.horizontal)
    }
}
