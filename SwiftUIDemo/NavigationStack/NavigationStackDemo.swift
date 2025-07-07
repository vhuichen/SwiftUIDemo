//
//  NavigationStackDemo.swift
//  SwiftUIDemo
//
//  Created by chenhui on 2025/7/7.
//

import SwiftUI

struct NavigationStackDemo: View {
    @State private var path = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $path) {
            List {
                Button("Show String Detail") {
                    path.append("stringDetail")
                }
                
                Button("Show Number Detail") {
                    path.append(42)
                }
                
                Button("Show Custom Detail") {
                    path.append(CustomData(name: "Example"))
                }
            }
            .navigationDestination(for: String.self) { value in
                Text("String Detail: \(value)")
            }
            .navigationDestination(for: Int.self) { value in
                Text("Number Detail: \(value)")
            }
            .navigationDestination(for: CustomData.self) { value in
                Text("Custom Detail: \(value.name)")
            }
            .navigationTitle("首页")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct CustomData: Hashable {
    let name: String
}

@available(iOS 17.0, *)
#Preview {
    NavigationStackDemo()
}
