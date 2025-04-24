//
//  HomeCard.swift
//  Bookish
//
//  Created by Jonas Niyazson on 2025-04-24.
//

import SwiftUI

struct HomeCardView<Destination: View>: View {
    let title: String
    let color: Color
    let icon: String
    let destination: Destination

    var body: some View {
        NavigationLink(destination: destination) {
            VStack(spacing: 10) {
                Image(systemName: icon)
                    .font(.largeTitle)
                Text(title)
                    .font(.headline)
                    .multilineTextAlignment(.center)
            }
            .foregroundColor(.white)
            .padding()
            .frame(maxWidth: .infinity, minHeight: 120)
            .background(color)
            .cornerRadius(16)
            .shadow(radius: 4)
        }
    }
}

#Preview {
    NavigationView {
        HomeCardView(
            title: "New Books",
            color: .blue,
            icon: "book.fill",
            destination: Text("Destination View")
        )
        .padding()
    }
}

