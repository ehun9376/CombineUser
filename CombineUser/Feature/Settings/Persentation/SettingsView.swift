//
//  SettingsView.swift
//  CombineUser
//
//  Created by 陳逸煌 on 2025/9/30.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Image(systemName: "gear")
                    .font(.system(size: 60))
                    .foregroundColor(.gray)
                
                Text("Settings")
                    .font(.title)
                    .fontWeight(.bold)
                
                Text("Future features will be added here")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            .navigationTitle("Settings")
        }
    }
}
