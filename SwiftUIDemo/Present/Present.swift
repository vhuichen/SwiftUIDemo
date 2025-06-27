//
//  Present.swift
//  SwiftUIDemo
//
//  Created by chenhui on 2025/6/25.
//

import SwiftUI

struct ModalDemoView: View {
    @State private var isPresented = false
    @State private var fullScreen = false
    @State private var showAlert = false
    @State private var showDialog = false
    @State private var showPopover = false
    @State private var showOverlay = false

    var body: some View {
        ZStack {
            VStack {
                
                Text("主视图内容")
                    .padding()
                Button("显示模态视图") {
                    isPresented = true
                }
                .padding()
                Button("显示全屏模态") {
                    fullScreen = true
                }
                .padding()
                Button("显示弹窗") {
                    showAlert = true
                }
                .padding()
                Button("显示选择菜单") {
                    showDialog = true
                }
                .padding()
                Button("显示Popover") {
                    showPopover = true
                }
                .padding()
                Button("显示覆盖层") {
                    withAnimation {
                        showOverlay = true
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        withAnimation {
                            showOverlay = false
                        }
                    }
                }
                .padding()
            }
            
            if showOverlay {
                Color.black.opacity(0.5)
                    .edgesIgnoringSafeArea(.all)
                    .transition(.opacity)
                VStack {
                    Text("这是一个自定义覆盖层")
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                }
                .transition(.scale)
            }
            
        }
        .sheet(isPresented: $isPresented) {
            ModalView()
        }
        .fullScreenCover(isPresented: $fullScreen) {
            FullScreenModalView()
        }
        .alert("警告", isPresented: $showAlert) {
            Button("取消") {
                debugPrint("点击了取消")
            }
            Button("确定") {
                debugPrint("点击了确定")
            }
        } message: {
            Text("这是一个重要的警告信息")
        }
        .confirmationDialog("请选择", isPresented: $showDialog) {
            Button("选项1") { debugPrint("选择了选项1") }
            Button("选项2") { debugPrint("选择了选项2") }
        }
        .popover(isPresented: $showPopover) {
            // 只适用于iPad
            VStack {
                Text("Popover内容").padding()
                Button("关闭") {
                    showPopover = false
                }
            }
            .frame(width: 200, height: 150)
        }
    }
}

struct ModalView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            Text("这是模态视图")
                .padding()
            Button("关闭") {
                dismiss()
            }
        }
    }
}

struct FullScreenModalView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            Color.blue.ignoresSafeArea()
            
            VStack {
                Text("这是全屏模态视图")
                    .foregroundColor(.white)
                
                Button("关闭") {
                    dismiss()
                }
                .padding()
                .background(Color.white)
                .cornerRadius(8)
            }
        }
    }
}

#Preview {
    ModalDemoView()
}
