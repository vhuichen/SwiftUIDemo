//
//  APP.swift
//  SwiftUIDemo
//
//  Created by chenhui on 2025/6/27.
//

import SwiftUI

struct APPContentView: View {
    @StateObject private var homeRouter = RouterService()
    @StateObject private var mineRouter = RouterService()
    
    var body: some View {
        TabView {
            PYNavigationStack {
                HomeView()
            }
            .environmentObject(homeRouter)
            .tabItem {
                Label("首页", systemImage: "house")
            }
            
            PYNavigationStack {
                MineView()
            }
            .environmentObject(mineRouter)
            .tabItem {
                Label("我的", systemImage: "person")
            }
        }
    }
}

@available(iOS 17.0, *)
#Preview {
    APPContentView()
}

