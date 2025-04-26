//
//  BottomTabBarView.swift
//  dealdash-ios
//
//  Created by Gevindu Piyumal on 2025-04-23.
//

import SwiftUI

struct BottomTabBarView: View {
    var body: some View {
        TabView {
            HomeView().tabItem { Label("Home", systemImage: "house") }
            Text("List").tabItem { Label("List", systemImage: "list.bullet") }
            MapView().tabItem { Label("Map", systemImage: "map") }
            SavedDealsView().tabItem { Label("Saved", systemImage: "bookmark") }
        }
    }
}
