//
//  ReciprocityCard.swift
//  Ansel
//
//  Created by Tyler Reckart on 8/17/22.
//

import SwiftUI

struct ReciprocityCard: View {
    var label: String
    var icon: String
    var result: String
    var background: Color
    var foreground: Color = .white

    var body: some View {
        VStack {
            Image(systemName: icon)
                .imageScale(.large)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, 1)
            Text(label)
                .font(.system(.caption))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, 1)
            Spacer()
            Text(result)
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.system(.title, design: .rounded))
        }
        .foregroundColor(foreground)
        .frame(height:125, alignment: .topLeading)
        .padding()
        .background(background)
        .cornerRadius(18)
        .shadow(color: Color.black.opacity(0.05), radius: 12, x: 0, y: 10)
    }
}