//
//  Home.swift
//  SwiftUIDemo
//
//  Created by chenhui on 2025/6/27.
//

import SwiftUI


struct HomeView: View {
    @EnvironmentObject var router: RouterService
    
    var body: some View {
        List {
            Section("商品") {
                Button("查看手机商品") {
                    router.navigate(to: .product(.list(category: "手机")))
                }
                
                Button("查看电脑商品") {
                    router.navigate(to: .product(.list(category: "电脑")))
                }
                
                Button("查看示例商品详情") {
                    router.navigateToProductDetail(productID: "12345")
                }
            }
            
            Section("订单") {
                Button("查看订单历史") {
                    router.navigateToOrderHistory()
                }
            }
        }
        .navigationTitle("首页")
        .navigationBarTitleDisplayMode(.inline)
    }
}
