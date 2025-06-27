//
//  AnimationView.swift
//  SwiftUIDemo
//
//  Created by chenhui on 2025/6/25.
//

import SwiftUI

struct ImplicitAnimationView: View {
    @State private var isAnimating = false
    
    var body: some View {
        VStack {
            Circle()
                .fill(isAnimating ? .blue : .red)
                .frame(width: isAnimating ? 100 : 50, height: isAnimating ? 100 : 50)
                .animation(.easeInOut(duration: 1), value: isAnimating)
                .padding()
            Button("隐式动画") {
                isAnimating.toggle()
            }
        }
    }
}

#Preview("隐式动画") {
    ImplicitAnimationView()
}



struct ExplicitAnimationView: View {
    @State private var isAnimating = false
    
    var body: some View {
        VStack {
            Circle()
                .fill(isAnimating ? .blue : .red)
                .frame(width: isAnimating ? 100 : 50, height: isAnimating ? 100 : 50)
                .padding()
                
            Button("显式动画") {
                withAnimation(.spring(response: 0.5, dampingFraction: 0.6)) {
                    isAnimating.toggle()
                }
            }
        }
    }
}

#Preview("显式动画") {
    ExplicitAnimationView()
}


struct TransitionView: View {
    @State private var showView = false
    
    var body: some View {
        VStack {
            if showView {
                RoundedRectangle(cornerRadius: 10)
                    .fill(.blue)
                    .frame(width: 200, height: 100)
                    .transition(.asymmetric(
                        insertion: .move(edge: .leading),
                        removal: .move(edge: .trailing)
                    ))
            } else {
                RoundedRectangle(cornerRadius: 10)
                    .fill(.clear)
                    .frame(width: 200, height: 100)
            }
            
            Button("过渡动画") {
                withAnimation(.easeInOut(duration: 1)) {
                    showView.toggle()
                }
            }
        }
    }
}

#Preview("过渡动画") {
    TransitionView()
}


struct CombinedAnimationView: View {
    @State private var isAnimating = false
    
    var body: some View {
        VStack {
            Circle()
                .fill(isAnimating ? .blue : .red)
                .frame(width: isAnimating ? 100 : 50)
                .scaleEffect(isAnimating ? 1.3 : 1)
                .rotationEffect(.degrees(isAnimating ? 360 : 0))
                .animation(
                    isAnimating ? .easeInOut(duration: 1).repeatForever(autoreverses: true) : .easeInOut(duration: 1),
                    value: isAnimating
                )
                .padding()
            
            
            Button("组合动画") {
                isAnimating.toggle()
            }
        }
    }
}

#Preview("组合动画") {
    CombinedAnimationView()
}
