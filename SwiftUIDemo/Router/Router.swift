//
//  Router.swift
//  SwiftUIDemo
//
//  Created by chenhui on 2025/6/27.
//

import SwiftUI

// 基础路由协议
protocol ModuleRoute: Hashable, Identifiable {
    associatedtype Destination: View
    @ViewBuilder var destination: Destination { get }
}

// 类型擦除包装器
struct AnyRoute: Hashable, Identifiable {
    let id: AnyHashable
    private let _destination: () -> AnyView
    private let _equals: (Any) -> Bool
    private let _hash: (inout Hasher) -> Void
    private let base: Any
    
    init<R: ModuleRoute>(_ route: R) {
        self.id = route.id
        self.base = route
        self._destination = { AnyView(route.destination) }
        
        // 保存原始类型的 Equatable 实现
        self._equals = {
            guard let other = $0 as? R else { return false }
            return route == other
        }
        
        // 保存原始类型的 Hashable 实现
        self._hash = {
            route.hash(into: &$0)
        }
    }
    
    @ViewBuilder var destination: some View {
        _destination()
    }
    
    // 实现 Equatable
    static func == (lhs: AnyRoute, rhs: AnyRoute) -> Bool {
        lhs._equals(rhs.base)
    }
    
    // 实现 Hashable
    func hash(into hasher: inout Hasher) {
        _hash(&hasher)
    }
}
