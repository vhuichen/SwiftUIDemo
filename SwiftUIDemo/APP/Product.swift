//
//  Product.swift
//  SwiftUIDemo
//
//  Created by chenhui on 2025/6/27.
//

import SwiftUI

// 商品模块路由
enum ProductRoute: ModuleRoute {
    case detail(id: String)
    case list(category: String)
    
    var id: String {
        switch self {
        case .detail: return "product_detail"
        case .list: return "product_list"
        }
    }
    
    @ViewBuilder var destination: some View {
        switch self {
        case .detail(let id):
            ProductDetailView(productID: id)
        case .list(let category):
            ProductListView(category: category)
        }
    }
}

// 商品模块视图
struct ProductDetailView: View {
    let productID: String
    
    var body: some View {
        VStack {
            Text("商品详情")
            Text("商品ID: \(productID)")
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .navigationTitle("商品详情")
    }
}

struct ProductListView: View {
    let category: String
    
    var body: some View {
        List(1..<10) { i in
            Text("\(category)商品 \(i)")
        }
        .navigationTitle("\(category)列表")
    }
}
