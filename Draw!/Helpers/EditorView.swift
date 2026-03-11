//
//  EditorView.swift
//  Draw!
//
//  Created by TrungAnhx on 11/3/26.
//

import SwiftUI
import PaperKit
import PencilKit

struct EditorView: View {
    var size: CGSize
    var data: EditorData
    
    var body: some View {
        if let controller = data.controller {
            PaperControllerView(controller: controller)
        } else {
            ProgressView()
                .onAppear() {
                    data.initializeController(.init(origin: .zero, size: size))
                }
        }
    }
}

/// Paper Controller View
fileprivate struct PaperControllerView: UIViewControllerRepresentable {
    var controller: PaperMarkupViewController
    func makeUIViewController(context: Context) -> PaperMarkupViewController {
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
    
    
}

