//
//  SwiftUI_in_UIKitObservableObject.swift
//  SwiftUIDemo
//
//  Created by chenhui on 2025/6/18.
//

import UIKit
import SwiftUI
import SnapKit
import Combine

final class SharedData: ObservableObject {
    @Published var uiKitMessage = "UIKit初始数据"
    @Published var swiftUIMessage = "SwiftUI初始数据"
    var counter0 = 0
    var counter1 = 0
}

class UIKitHostViewController: UIViewController {
    private let sharedData = SharedData()
    
    private var hostingController: UIHostingController<EmbeddedSwiftUIView>!
    private var cancellables = Set<AnyCancellable>()
    
    private let messageLabel = UILabel()
    private let updateButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupSwiftUIHosting()
        setupDataBinding()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0
        view.addSubview(messageLabel)
        
        updateButton.setTitle("点击更新SwiftUI数据", for: .normal)
        updateButton.addTarget(self, action: #selector(updateSwiftUIData), for: .touchUpInside)
        view.addSubview(updateButton)
        
        updateButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.width.equalTo(200)
            make.height.equalTo(44)
        }
        
        messageLabel.snp.makeConstraints { make in
            make.top.equalTo(updateButton.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
        }
    }
    
    private func setupSwiftUIHosting() {
        hostingController = UIHostingController(
            rootView: EmbeddedSwiftUIView(
                data: sharedData,
                onButtonTap: { [weak self] in
                    self?.handleSwiftUIButtonTap()
                }
            )
        )
        
        addChild(hostingController)
        view.addSubview(hostingController.view)
        
        hostingController.view.snp.makeConstraints { make in
            make.top.equalTo(messageLabel.snp.bottom).offset(20)
            make.left.right.equalToSuperview()
            make.height.equalTo(200)
        }
        
        hostingController.didMove(toParent: self)
    }
    
    private func setupDataBinding() {
        sharedData.$swiftUIMessage
            .receive(on: DispatchQueue.main)
            .sink { [weak self] message in
                self?.messageLabel.text = "收到SwiftUI数据: \(message)"
            }
            .store(in: &cancellables)
    }
    
    @objc private func updateSwiftUIData() {
        sharedData.counter0 += 1
        sharedData.uiKitMessage = "\(sharedData.counter0)"
    }
    
    private func handleSwiftUIButtonTap() {
        sharedData.counter1 += 1
        sharedData.swiftUIMessage = "\(sharedData.counter1)"
    }
}


struct EmbeddedSwiftUIView: View {
    @ObservedObject var data: SharedData
    var onButtonTap: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Text("收到UIKit数据: \(data.uiKitMessage)")
                .font(.headline)
            TextField("输入内容回传UIKit", text: $data.swiftUIMessage)
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal)
            Button("点击更新UIKit数据") {
                data.counter1 += 1
                onButtonTap()
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .background(Color(.secondarySystemBackground))
    }
}

@available(iOS 17.0, *)
#Preview {
    UIKitHostViewController()
}
