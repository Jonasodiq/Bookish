//
//  HomeCard.swift
//  Bookish
//
//  Created by Jonas Niyazson on 2025-04-24.
//

import SwiftUI

struct HomeCard: View {
    let title: String
    let color: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding()
            }
            .frame(maxWidth: .infinity, minHeight: 100)
            .background(color)
            .cornerRadius(16)
            .shadow(radius: 4)
        }
    }
}


#Preview {
    HomeCard()
}
