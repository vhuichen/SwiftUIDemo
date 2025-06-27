//
//  SwiftUI_in_UIKitViewController.swift
//  SwiftUI_UIKit
//
//  Created by ChenHui on 2025/2/11.
//

import UIKit
import SwiftUI

class SwiftUI_in_UIKitViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        let hostingController = UIHostingController(rootView: SwiftUIView())
        addChild(hostingController)
        view.addSubview(hostingController.view)
        hostingController.view.backgroundColor = .red
        hostingController.didMove(toParent: self)
        hostingController.view.snp.makeConstraints { make in
            make.top.equalTo(200)
            make.left.equalTo(100)
        }
    }
}

private struct SwiftUIView: View {
    var body: some View {
        VStack {
            Text("Hello from SwiftUI! 1")
            Text("Hello from SwiftUI! 2")
            Text("Hello from SwiftUI! 3")
            Button("Tap") {
                debugPrint("click button !!!")
            }
            .padding(EdgeInsets(top: 10, leading: 50, bottom: 10, trailing: 50))
            .background(Color.gray)
            .foregroundColor(.white)
            .cornerRadius(5)
        }
        .background(Color.blue)
        .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
    }
}

@available(iOS 17.0, *)
#Preview {
    SwiftUI_in_UIKitViewController()
}
