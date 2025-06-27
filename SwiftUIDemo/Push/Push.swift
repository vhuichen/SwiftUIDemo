//
//  Presented.swift
//  SwiftUIDemo
//
//  Created by chenhui on 2025/6/25.
//

import SwiftUI

struct PushView: View {
    var body: some View {
        if #available(iOS 16.0, *) {
            NavigationStack {
                VStack {
                    NavigationLink("跳转到详情页", destination: PushDetailView())
                        .padding()
                    Text("这是首页内容")
                }
                .navigationTitle("首页16")
            }
        } else {
            NavigationView {
                VStack {
                    NavigationLink("跳转到详情页", destination: PushDetailView())
                        .padding()
                    Text("这是首页内容")
                }
                .navigationTitle("首页15")
            }
            .navigationViewStyle(.stack)
        }
    }
}

struct PushDetailView: View {
    var body: some View {
        VStack {
            Text("这是详情页内容")
                .padding()
            NavigationLink("跳转到更深层级", destination: PushThirdView())
        }
        .navigationTitle("详情页")
    }
}

struct PushThirdView: View {
    var body: some View {
        Text("这是第三级页面")
            .navigationTitle("第三页")
    }
}

#Preview {
    PushView()
}
