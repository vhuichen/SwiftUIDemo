//
//  UIKit_in_SwiftUIView.swift
//  SwiftUI_UIKit
//
//  Created by ChenHui on 2025/2/11.
//

import SwiftUI
import SnapKit

struct UIKit_in_SwiftUIView: View {
    @State private var sharedText = "Initial Text"
    
    var body: some View {
        VStack {
            Button("Update Time") {
                sharedText = "\(Date())"
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
            Text("Hello, World!")
            MyUILabel(text: $sharedText, buttonTitle: "我是UIKit，请点击") {
                print("点击了")
            }
            .border(Color.red)
            .fixedSize()
            Text("SwiftUI " + sharedText)
        }
    }
}

#Preview {
    UIKit_in_SwiftUIView()
}

class CustomView: UIView {
    var height = 120.0
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.red.withAlphaComponent(0.3)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .red
        return label
    }()
    
    lazy var button: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.green.withAlphaComponent(0.3)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        setupUI()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        backgroundColor = UIColor.yellow.withAlphaComponent(0.3)
        
        addSubview(titleLabel)
        addSubview(button)
        
        titleLabel.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
        }
        
        button.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    func update(title:String, buttonTitle:String) {
        titleLabel.text = "UIKit " + title
        button.setTitle(buttonTitle, for: .normal)
        height = 100
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 300, height: height)
    }
}

private struct MyUILabel: UIViewRepresentable {
    @Binding var text: String
    var buttonTitle: String
    var action: (() -> Void)?
    
    func makeUIView(context: Context) -> UIView {
        let view = CustomView()
        
        view.button.addTarget(context.coordinator,
                              action: #selector(Coordinator.buttonTapped),
                              for: .touchUpInside)
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        if let view = uiView as? CustomView {
            view.update(title: text, buttonTitle: buttonTitle)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject {
        var parent: MyUILabel
        init(_ parent: MyUILabel) {
            self.parent = parent
        }
        
        @objc func buttonTapped() {
            parent.text = "\(Date())"
            parent.action?()
        }
    }
    
}
