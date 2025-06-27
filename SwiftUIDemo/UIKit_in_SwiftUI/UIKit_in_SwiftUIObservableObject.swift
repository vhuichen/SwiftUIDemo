//
//  ObservableObject.swift
//  SwiftUIDemo
//
//  Created by chenhui on 2025/6/18.
//

import UIKit
import Combine
import SwiftUI

class SharedDataModel: ObservableObject {
    @Published var text: String = "Initial Text"
    @Published var counter: Int = 0
}

class UIKitView: UIView {
    private let label = UILabel()
    private let button = UIButton(type: .system)
    private var cancellables = Set<AnyCancellable>()
    
    var dataModel: SharedDataModel? {
        didSet {
            bindDataModel()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        label.textAlignment = .center
        label.numberOfLines = 0
        addSubview(label)
        label.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalToSuperview().inset(20)
        }
        
        button.setTitle("Update from UIKit", for: .normal)
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        addSubview(button)
        button.snp.makeConstraints { make in
            make.top.equalTo(label.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
    }
    
    private func bindDataModel() {
        guard let dataModel = dataModel else {
            return
        }
        dataModel.$text.receive(on: DispatchQueue.main).sink { [weak self] newText in
            self?.label.text = "\(newText)\nCounter: \(dataModel.counter)"
        }
        .store(in: &cancellables)
    }
    
    @objc private func buttonTapped() {
        dataModel?.text = "\(Date())"
        dataModel?.counter += 1
    }
    
    deinit {
        cancellables.forEach { $0.cancel() }
    }
}

struct UIKitRepresentable: UIViewRepresentable {
    @ObservedObject var dataModel: SharedDataModel
    
    func makeUIView(context: Context) -> UIKitView {
        let view = UIKitView()
        view.dataModel = dataModel
        return view
    }
    
    func updateUIView(_ uiView: UIKitView, context: Context) {
        // 由于使用了 Combine 绑定，这里不需要额外操作
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject {
        var parent: UIKitRepresentable
        
        init(_ parent: UIKitRepresentable) {
            self.parent = parent
        }
    }
}

struct ContentView: View {
    @StateObject private var dataModel = SharedDataModel()
    
    var body: some View {
        VStack(spacing: 20) {
            VStack {
                Text(dataModel.text)
                    .font(.title2)
                Text("Counter: \(dataModel.counter)")
                    .font(.headline)
            }
            
            Button("Update from SwiftUI") {
                dataModel.text = "\(Date())"
                dataModel.counter += 1
            }
            
            UIKitRepresentable(dataModel: dataModel)
                .frame(height: 200)
                .background(Color.gray.opacity(0.2))
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
