//
//  Mine.swift
//  SwiftUIDemo
//
//  Created by chenhui on 2025/6/27.
//

import SwiftUI


struct MineView: View {
    @EnvironmentObject var router: RouterService
    
    var body: some View {
        List {
            Button("我的资料") {
                router.navigateToUserProfile(userID: "user123")
            }
            
            Button("设置") {
                router.navigate(to: .user(.settings))
            }
            
            Button("我的订单") {
                router.navigateToOrderHistory()
            }
        }
    }
}
