//
//  User.swift
//  SwiftUIDemo
//
//  Created by chenhui on 2025/6/27.
//

import SwiftUI

// 用户模块路由
enum UserRoute: ModuleRoute {
    case profile(id: String)
    case settings
    
    var id: String {
        switch self {
        case .profile: return "user_profile"
        case .settings: return "user_settings"
        }
    }
    
    @ViewBuilder var destination: some View {
        switch self {
        case .profile(let id):
            UserProfileView(userID: id)
        case .settings:
            UserSettingsView()
        }
    }
}

// 用户模块视图
struct UserProfileView: View {
    let userID: String
    
    var body: some View {
        VStack {
            Text("用户个人资料")
            Text("用户ID: \(userID)")
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .navigationTitle("个人资料")
    }
}

struct UserSettingsView: View {
    var body: some View {
        List {
            Text("通知设置")
            Text("隐私设置")
            Text("账户安全")
        }
        .navigationTitle("设置")
    }
}
