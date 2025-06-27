//
//  Navigation.swift
//  SwiftUIDemo
//
//  Created by chenhui on 2025/6/26.
//

import SwiftUI

struct CompatibleNavBarView: View {
    @State private var showAlert = false
    @State private var favoriteCount = 0
    @State private var isEditing = false
    @State private var selectedOption = "无"
    
    var body: some View {
        navigationContainer
    }
    
    @ViewBuilder
    private var navigationContainer: some View {
        if #available(iOS 16, *) {
            NavigationStack {
                mainContentView
            }
        } else {
            NavigationView {
                mainContentView
            }
            .navigationViewStyle(.stack)
        }
        makeTwoTextsViewBuilder()
    }
    
    private var mainContentView: some View {
        List {
            Section {
                Text("当前选项: \(selectedOption)")
                Text("收藏数: \(favoriteCount)")
                Text("编辑状态: \(isEditing ? "编辑中" : "浏览")")
            }
            
            Section("数据列表") {
                ForEach(1..<5) { index in
                    Text("项目 \(index)")
                }
                .onDelete(perform: deleteItems)
            }
        }
        .navigationTitle("兼容示例")
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("帮助") {
                    showAlert = true
                }
            }
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                editButton
                favoriteButton
                moreOptionsMenu
            }
        }
        .alert("帮助信息", isPresented: $showAlert) {
            Button("确定", role: .cancel) {}
        } message: {
            Text("这是一个兼容 iOS 15 和 16 的导航栏按钮示例")
        }
        .environment(\.editMode, isEditing ? .constant(.active) : .constant(.inactive))
    }
    
    // 编辑按钮
    private var editButton: some View {
        Button(isEditing ? "完成" : "编辑") {
            isEditing.toggle()
        }
    }
    
    // 收藏按钮
    private var favoriteButton: some View {
        Button {
            favoriteCount += 1
        } label: {
            Label("收藏", systemImage: "heart.fill")
        }
    }
    
    private var moreOptionsMenu: some View {
        Group {
            if #available(iOS 16, *) {
                Menu {
                    menuContent
                } label: {
                    Image(systemName: "ellipsis.circle")
                }
                .menuOrder(.fixed)
            } else {
                Menu {
                    menuContent
                } label: {
                    Image(systemName: "ellipsis.circle")
                }
            }
        }
    }
    
    private var menuContent: some View {
        Group {
            Button("设置") {
                selectedOption = "设置"
            }
            Button("关于") {
                selectedOption = "关于"
            }
            Divider()
            Button("刷新数据", systemImage: "arrow.clockwise") {
                selectedOption = "刷新数据"
            }
        }
    }
    
    private func deleteItems(at offsets: IndexSet) {
        print("删除项目: \(offsets)")
    }
}

#Preview {
    CompatibleNavBarView()
}
