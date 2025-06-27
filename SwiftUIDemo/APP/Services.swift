//
//  Services.swift
//  SwiftUIDemo
//
//  Created by chenhui on 2025/6/27.
//

import SwiftUI

// 应用路由枚举
enum AppRoute {
    case user(UserRoute)
    case product(ProductRoute)
    case order(OrderRoute)
    
    var anyRoute: AnyRoute {
        switch self {
        case .user(let route):
            return AnyRoute(route)
        case .product(let route):
            return AnyRoute(route)
        case .order(let route):
            return AnyRoute(route)
        }
    }
}

// 路由服务
class RouterService: ObservableObject {
    @Published var path = NavigationPath()
    
    func navigate(to route: AppRoute) {
        path.append(route.anyRoute)
    }
    
    func navigateBack() {
        path.removeLast()
    }
    
    func popToRoot() {
        path.removeLast(path.count)
    }
    
    // 模块特定导航方法
    func navigateToUserProfile(userID: String) {
        navigate(to: .user(.profile(id: userID)))
    }
    
    func navigateToProductDetail(productID: String) {
        navigate(to: .product(.detail(id: productID)))
    }
    
    func navigateToOrderHistory() {
        navigate(to: .order(.history))
    }
}
