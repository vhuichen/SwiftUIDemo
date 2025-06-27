//
//  APP.swift
//  SwiftUIDemo
//
//  Created by chenhui on 2025/6/27.
//

import SwiftUI

struct APPContentView: View {
    @EnvironmentObject var router: RouterService
    
    var body: some View {
        TabView {
            PYNavigationStack {
                HomeView()
                    .navigationTitle("首页")
                    .navigationBarTitleDisplayMode(.inline)
            }
            .tabItem {
                Label("首页", systemImage: "house")
            }
            PYNavigationStack {
                MineView()
                    .navigationTitle("我的")
                    .navigationBarTitleDisplayMode(.inline)
            }
            .tabItem {
                Label("我的", systemImage: "person")
            }
        }
    }
}

@available(iOS 17.0, *)
#Preview {
    @Previewable @StateObject var router = RouterService()
    NavigationStack(path: $router.path) {
        APPContentView()
            .navigationDestination(for: AnyRoute.self) { route in
                route.destination
            }
    }
    .environmentObject(router)
}

