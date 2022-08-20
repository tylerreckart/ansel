//
//  ContentView.swift
//  Ansel
//
//  Created by Tyler Reckart on 7/9/22.
//

import SwiftUI

struct NavigationCard: View {
    var label: String
    var icon: String
    var background: Color

    var body: some View {
        VStack(alignment: .leading) {
            Image(systemName: icon)
                .imageScale(.large)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, 1)
                .foregroundColor(.white)
            Text(label)
                .font(.system(.body))
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundColor(.white)
                .multilineTextAlignment(.leading)
        }
        .frame(maxWidth: .infinity, minHeight: 80, alignment: .topLeading)
        .padding()
        .background(background)
        .cornerRadius(18)
    }
}

struct Home: View {
    var body: some View {
        return NavigationView {
            VStack {
                Text("Field Tools")
                    .font(.system(.caption))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(.gray)
                    .padding(.top)

                HStack {
                    NavigationLink(destination: Notes()) {
                        NavigationCard(
                            label: "Notes",
                            icon: "bookmark.circle.fill",
                            background: Color(.systemYellow)
                        )
                        .shadow(color: Color.black.opacity(0.05), radius: 12, x: 0, y: 10)
                        .badge(2)
                        .tabItem {
                            Label("Received", systemImage: "tray.and.arrow.down.fill")
                        }
                    }
                }
                
                Text("Exposure Compensation Tools")
                    .font(.system(.caption))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(.gray)
                    .padding(.top)
                
                HStack {
                    NavigationLink(destination: Reciprocity()) {
                        NavigationCard(
                            label: "Reciprocity Factor",
                            icon: "clock.circle.fill",
                            background: Color(.systemPurple)
                        )
                        .shadow(color: Color.black.opacity(0.05), radius: 12, x: 0, y: 10)
                    }

                    NavigationLink(destination: BellowsExtension()) {
                        NavigationCard(
                            label: "Bellows Extension Factor",
                            icon: "arrow.up.left.and.arrow.down.right.circle.fill",
                            background: Color(.systemBlue)
                        )
                        .shadow(color: Color.black.opacity(0.05), radius: 12, x: 0, y: 10)
                    }
                }
                
                HStack {
                    NavigationLink(destination: FilterFactor()) {
                        NavigationCard(
                            label: "Filter Factor",
                            icon: "moon.circle.fill",
                            background: Color(.systemGreen)
                        )
                        .shadow(color: Color.black.opacity(0.05), radius: 12, x: 0, y: 10)
                    }
                }

                Spacer()
            }
            .padding()
            .navigationTitle("Ansel")
            .navigationBarTitleDisplayMode(.inline)
            .background(Color(.systemGray6))
        }
    }
}

struct ContentView: View {
    var body: some View {
        Home()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
