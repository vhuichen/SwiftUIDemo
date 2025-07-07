//
//  Common.swift
//  SwiftUIDemo
//
//  Created by chenhui on 2025/6/27.
//

import SwiftUI

struct PYNavigationStack<Content: View>: View {
    private let content: Content
    @EnvironmentObject var router: RouterService
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        if #available(iOS 16, *) {
            NavigationStack(path: $router.path) {
                content.navigationDestination(for: AnyRoute.self) { route in
                    route.destination
                }
            }
        } else {
            NavigationView {
                content
            }
            .navigationViewStyle(.stack)
        }
    }
}
