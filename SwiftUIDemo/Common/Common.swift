//
//  Common.swift
//  SwiftUIDemo
//
//  Created by chenhui on 2025/6/27.
//

import SwiftUI

struct PYNavigationStack<Content: View>: View {
    private let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        if #available(iOS 16, *) {
            NavigationStack {
                content
            }
        } else {
            NavigationView {
                content
            }
            .navigationViewStyle(.stack)
        }
    }
}
