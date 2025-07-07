//
//  NavigationViewDemo.swift
//  SwiftUIDemo
//
//  Created by chenhui on 2025/7/7.
//

import SwiftUI

// MARK: - 数据模型
struct CartItem: Hashable, Identifiable {
    let id: Int
    let name: String
    let price: Double
}

// MARK: - 路由枚举
enum AppRouteNV: Hashable {
    case productDetailNV(id: Int)
    case userProfileNV(username: String)
    case settingsNV
    case checkoutNV(items: [CartItem])
    
    func hash(into hasher: inout Hasher) {
        switch self {
        case .productDetailNV(let id):
            hasher.combine("productDetailNV")
            hasher.combine(id)
        case .userProfileNV(let username):
            hasher.combine("userProfileNV")
            hasher.combine(username)
        case .settingsNV:
            hasher.combine("settingsNV")
        case .checkoutNV(let items):
            hasher.combine("checkoutNV")
            hasher.combine(items)
        }
    }
}

// MARK: - 路由管理器
class RouterNV: ObservableObject {
    @Published var path: [AppRouteNV] = []
    
    func navigate(to route: AppRouteNV) {
        path.append(route)
    }
    
    func navigateBack() {
        if !path.isEmpty {
            path.removeLast()
        }
    }
    
    func popToRoot() {
        path.removeAll()
    }
}

// MARK: - 路由视图扩展
extension AppRouteNV {
    @ViewBuilder var destinationViewNV: some View {
        switch self {
        case .productDetailNV(let id):
            ProductDetailNVView(productId: id)
        case .userProfileNV(let username):
            UserProfileNVView(username: username)
        case .settingsNV:
            SettingsNVView()
        case .checkoutNV(let items):
            CheckoutNVView(items: items)
        }
    }
}

// MARK: - 兼容导航容器
struct CompatibleNavigationContainerNV<Content: View>: View {
    @ViewBuilder let content: Content
    @EnvironmentObject var router: RouterNV
    
    var body: some View {
        if #available(iOS 16, *) {
            NavigationStack(path: $router.path) {
                content
                    .navigationDestination(for: AppRouteNV.self) { route in
                        route.destinationViewNV
                    }
            }
        } else {
            NavigationView {
                content
                    .background(
                        NavigationLink(
                            destination: router.path.last?.destinationViewNV,
                            isActive: Binding<Bool>(
                                get: { !router.path.isEmpty },
                                set: { newValue in
                                    if !newValue && !router.path.isEmpty {
                                        router.navigateBack()
                                    }
                                }
                            ),
                            label: { EmptyView() }
                        )
                        .hidden()
                    )
            }
            .navigationViewStyle(.stack)
        }
    }
}

// MARK: - 主入口视图
struct ContentNVView: View {
    @StateObject private var router = RouterNV()
    
    var body: some View {
        CompatibleNavigationContainerNV {
            HomeNVView()
        }
        .environmentObject(router)
    }
}

// MARK: - 首页视图
struct HomeNVView: View {
    @EnvironmentObject var router: RouterNV
    
    var body: some View {
        List {
            Section("产品") {
                Button("查看产品详情") {
                    router.navigate(to: .productDetailNV(id: 1001))
                }
                
                Button("查看促销产品") {
                    router.navigate(to: .productDetailNV(id: 2002))
                }
            }
            
            Section("用户") {
                Button("我的资料") {
                    router.navigate(to: .userProfileNV(username: "current_user"))
                }
                
                Button("他人资料") {
                    router.navigate(to: .userProfileNV(username: "other_user"))
                }
            }
            
            Section("系统") {
                Button("系统设置") {
                    router.navigate(to: .settingsNV)
                }
                
                Button("购物车结算") {
                    let items = [
                        CartItem(id: 1, name: "《SwiftUI实战》", price: 59.99),
                        CartItem(id: 2, name: "《Combine编程》", price: 49.99),
                        CartItem(id: 3, name: "《iOS性能优化》", price: 39.99)
                    ]
                    router.navigate(to: .checkoutNV(items: items))
                }
            }
        }
        .navigationTitle("首页")
        .toolbar {
            if #unavailable(iOS 16), !router.path.isEmpty {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        router.navigateBack()
                    }) {
                        Image(systemName: "chevron.backward")
                        Text("返回")
                    }
                }
            }
        }
    }
}

// MARK: - 产品详情视图
struct ProductDetailNVView: View {
    let productId: Int
    @EnvironmentObject var router: RouterNV
    
    var body: some View {
        VStack(spacing: 20) {
            Text("产品详情")
                .font(.largeTitle)
                .padding(.bottom, 20)
            
            VStack(alignment: .leading, spacing: 10) {
                Text("产品ID: \(productId)")
                    .font(.title2)
                
                Text("价格: \(productId % 100 == 0 ? "$99.99" : "$\(productId % 100).99")")
                    .font(.title3)
                    .foregroundColor(.blue)
                
                Text("描述: 这是产品\(productId)的详细描述信息，包含各种规格参数和使用说明。")
                    .font(.body)
                    .padding(.top, 10)
            }
            .padding()
            
            Spacer()
            
            Button("查看卖家资料") {
                router.navigate(to: .userProfileNV(username: "seller_\(productId)"))
            }
            .buttonStyle(.borderedProminent)
            
            Button("返回") {
                router.navigateBack()
            }
            .buttonStyle(.bordered)
            
            Button("返回首页") {
                router.popToRoot()
            }
            .padding(.top, 10)
        }
        .padding()
        .navigationTitle("产品详情")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - 用户资料视图
struct UserProfileNVView: View {
    let username: String
    @EnvironmentObject var router: RouterNV
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "person.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .foregroundColor(.blue)
            
            Text(username)
                .font(.title)
                .bold()
            
            Text("会员等级: \(username.count > 10 ? "高级" : "普通")")
                .font(.headline)
                .foregroundColor(.secondary)
            
            Divider()
                .padding(.vertical)
            
            VStack(alignment: .leading, spacing: 10) {
                Text("注册时间: 2023-01-01")
                Text("最后登录: 2023-06-15")
                Text("订单数量: \(username.count * 2)")
            }
            .font(.subheadline)
            
            Spacer()
            
            Button("查看设置") {
                router.navigate(to: .settingsNV)
            }
            .buttonStyle(.borderedProminent)
            
            Button("返回") {
                router.navigateBack()
            }
            .buttonStyle(.bordered)
        }
        .padding()
        .navigationTitle("用户资料")
    }
}

// MARK: - 设置视图
struct SettingsNVView: View {
    @EnvironmentObject var router: RouterNV
    @State private var notificationsEnabled = true
    @State private var darkModeEnabled = false
    @State private var fontSize: Double = 16
    
    var body: some View {
        Form {
            Section("偏好设置") {
                Toggle("启用通知", isOn: $notificationsEnabled)
                Toggle("深色模式", isOn: $darkModeEnabled)
                Slider(value: $fontSize, in: 12...24) {
                    Text("字体大小")
                }
                Text("当前大小: \(fontSize, specifier: "%.0f")")
                    .font(.system(size: fontSize))
            }
            
            Section("账户") {
                Button("修改密码") {
                    // 密码修改逻辑
                }
                
                Button("注销登录") {
                    router.popToRoot()
                }
                .foregroundColor(.red)
            }
            
            Section {
                Button("返回") {
                    router.navigateBack()
                }
                
                Button("返回首页") {
                    router.popToRoot()
                }
            }
        }
        .navigationTitle("设置")
    }
}

// MARK: - 结算视图
struct CheckoutNVView: View {
    let items: [CartItem]
    @EnvironmentObject var router: RouterNV
    @State private var paymentMethod = "信用卡"
    @State private var shippingAddress = ""
    
    var totalPrice: Double {
        items.reduce(0) { $0 + $1.price }
    }
    
    var body: some View {
        Form {
            Section("购物清单") {
                ForEach(items) { item in
                    HStack {
                        Text(item.name)
                        Spacer()
                        Text("$\(item.price, specifier: "%.2f")")
                    }
                }
                
                HStack {
                    Text("总计")
                        .bold()
                    Spacer()
                    Text("$\(totalPrice, specifier: "%.2f")")
                        .bold()
                }
            }
            
            Section("支付方式") {
                Picker("选择支付方式", selection: $paymentMethod) {
                    Text("信用卡").tag("信用卡")
                    Text("支付宝").tag("支付宝")
                    Text("微信支付").tag("微信支付")
                    Text("PayPal").tag("PayPal")
                }
                .pickerStyle(.menu)
            }
            
            Section("配送地址") {
                TextField("请输入配送地址", text: $shippingAddress)
            }
            
            Section {
                Button("确认支付") {
                    // 处理支付逻辑
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        router.popToRoot()
                    }
                }
                .disabled(shippingAddress.isEmpty)
                .frame(maxWidth: .infinity)
            }
            
            Section {
                Button("返回修改") {
                    router.navigateBack()
                }
                .foregroundColor(.secondary)
            }
        }
        .navigationTitle("订单结算")
    }
}

// 8. 预览提供程序
@available(iOS 17.0, *)
#Preview {
    ContentNVView()
}
