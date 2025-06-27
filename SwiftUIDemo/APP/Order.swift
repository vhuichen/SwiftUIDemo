//
//  Order.swift
//  SwiftUIDemo
//
//  Created by chenhui on 2025/6/27.
//

import SwiftUI

// 订单模块路由
enum OrderRoute: ModuleRoute {
    case history
    case detail(id: String)
    
    var id: String {
        switch self {
        case .history: return "order_history"
        case .detail: return "order_detail"
        }
    }
    
    @ViewBuilder var destination: some View {
        switch self {
        case .history:
            OrderHistoryView()
        case .detail(let id):
            OrderDetailView(orderID: id)
        }
    }
}

// 订单模块视图
struct OrderHistoryView: View {
    var body: some View {
        List(1..<5) { i in
            Text("历史订单 \(i)")
        }
        .navigationTitle("订单历史")
    }
}

struct OrderDetailView: View {
    let orderID: String
    
    var body: some View {
        VStack {
            Text("订单详情")
            Text("订单ID: \(orderID)")
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .navigationTitle("订单详情")
    }
}
