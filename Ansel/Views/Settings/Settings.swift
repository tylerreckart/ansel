//
//  SettingsView.swift
//  Aspen
//
//  Created by Tyler Reckart on 8/23/22.
//

import SwiftUI

struct Settings: View {
    var store: Store?

    var body: some View {
        VStack {
            List {
                Section {
                    NavigationLink(destination: FilmStocks()) {
                        Text("Film Stocks")
                    }
                    NavigationLink(destination: Cameras()) {
                        Text("Cameras")
                    }
                    NavigationLink(destination: Lenses()) {
                        Text("Lenses")
                    }
                }
                
//                Section {
//                    NavigationLink(destination: Subscription(store: store)) {
//                        Text("Aspen Premium")
//                    }
//                }

                Section(header: Text("Customization").font(.system(size: 12))) {
                    NavigationLink(destination: ThemeSettings()) {
                        Text("Theme")
                    }
                    NavigationLink(destination: AppIconSettings()) {
                        Text("App Icon")
                    }
                }
                
                Section(header: Text("Feedback").font(.system(size: 12))) {
                    NavigationLink(destination: Feedback()) {
                        Text("Send Feedback")
                    }
                }
                
                Section {
                    NavigationLink(destination: Privacy()) {
                        Text("Privacy Policy")
                    }
//                    NavigationLink(destination: Terms()) {
//                        Text("Terms of Use")
//                    }
                    NavigationLink(destination: About()) {
                        Text("About")
                    }
                }
            }
        }
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
    }
}
