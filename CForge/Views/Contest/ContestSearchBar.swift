//
//  ContestSearchBar.swift
//  CForge
//
//  Created by Khushi Patil on 11/04/26.
//

import SwiftUI

struct ContestSearchBar: View {
    @Binding var text: String
    let placeholder: String

    var body: some View {
        TextField(placeholder, text: $text)
            .padding()
            .background(Color.gray.opacity(0.2))
            .cornerRadius(10)
    }
}
