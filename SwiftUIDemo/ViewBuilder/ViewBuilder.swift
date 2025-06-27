//
//  ViewBuilder.swift
//  SwiftUIDemo
//
//  Created by chenhui on 2025/6/26.
//

import SwiftUI

@ViewBuilder
func makeTwoTextsViewBuilder() -> some View {
    Text("第一个文本1")
    Text("第二个文本2")
}

@ViewBuilder
func viewWithOptional(text: String?) -> some View {
    if let text = text {
        Text(text)
    } else {
        ProgressView()
    }
}

@ViewBuilder
var navigationContainerViewBuilder: some View {
    if #available(iOS 16, *) {
        NavigationStack {
            makeTwoTextsViewBuilder()
        }
    } else {
        NavigationView {
            makeTwoTextsViewBuilder()
        }
        .navigationViewStyle(.stack)
    }
    makeTwoTextsViewBuilder()
}

@ViewBuilder
func combinedViews() -> some View {
    // Group 作用
    // 1. 某些容器对子视图数量有限制（如 VStack 最多10个）, 此时可以用 Group 包装起来
    // 2. 还可以共享修饰符
    // 3. 提高代码可读性
    // 4. 逻辑分组，可读性提高
    Group {
        Text("第一部分")
        viewWithOptional(text: "haha")
    }
}

struct AdaptiveButton<Content: View>: View {
    let action: () -> Void
    let content: Content
    
    init(action: @escaping () -> Void, @ViewBuilder content: () -> Content) {
        self.action = action
        self.content = content()
    }
    
    var body: some View {
        Button(action: action) {
            content
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
        }
    }
}


struct MyContainer<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        VStack {
            combinedViews()
            content
            Text("内容1")
            AdaptiveButton {
                print("按钮点击")
            } content: {
                HStack {
                    Image(systemName: "plus")
                    Text("添加项目")
                }
            }
        }
        .padding()
    }
}


#Preview {
    MyContainer {
        Text("内容1")
        Text("内容2")
    }
}

