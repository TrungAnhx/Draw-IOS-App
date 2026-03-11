//
//  EditorData.swift
//  Draw!
//
//  Created by TrungAnhx on 11/3/26.
//

import SwiftUI
import PencilKit
import PaperKit

@Observable
class EditorData {
    var controller: PaperMarkupViewController?
    var markup: PaperMarkup?
    var toolPicker: PKToolPicker?
    
    func initializeController(_ rect: CGRect, welcomeText: String =  "Start Crafting!") {
        let controller = PaperMarkupViewController(supportedFeatureSet: .latest)
        let markup = PaperMarkup(bounds: rect)
        
        if let existingController = self.controller {
            existingController.markup = markup
            self.markup = markup
        } else {
            self.markup = markup
            self.controller = controller
            self.controller?.markup = markup
            self.controller?.zoomRange = 0.8...1.5
            
            /// Initializing Tool Picker
            self.toolPicker = PKToolPicker()
        }
        
        if !welcomeText.isEmpty {
            let text = NSAttributedString(string: welcomeText, attributes: [
                .font: UIFont.systemFont(ofSize: 18)
            ])
            
            let centerRect = text.centerRect(int: rect)
            insertText(text, rect: centerRect)
        }
    }
    
    /// Markup Editing Methods
    
    /// Insert Text
    func insertText(_ text: NSAttributedString, rect: CGRect) {
        markup?.insertNewTextbox(attributedText: text, frame: rect)
        refreshController()
    }
    
    /// Insert Image
    func insertImage(_ image: UIImage, rect: CGRect) {
        guard let cgImage = image.cgImage else { return }
        markup?.insertNewImage(cgImage, frame: rect)
        refreshController()
    }
    
    /// Insert Shape
    func insertShape(_ type: ShapeConfiguration, rect: CGRect) {
        markup?.insertNewShape(configuration: type, frame: rect)
        refreshController()
    }
    
    func showPencilKitTools(_ isVisible: Bool) {
        guard let controller else { return }
        
        /// Type 1
//        controller.view.pencilKitResponderState.activeToolPicker = toolPicker
//        controller.view.pencilKitResponderState.toolPickerVisibility = isVisible ? .visible : .hidden
        
        /// Type 2
        toolPicker?.addObserver(controller)
        toolPicker?.setVisible(isVisible, forFirstResponder: controller.view)
        
        if isVisible {
            controller.view.becomeFirstResponder()
        }
    }
    
    /// Updating Controller
    func refreshController() {
        controller?.markup = markup
    }
    
    /// Markup to Data/Image
    func exportAsImage(_ rect: CGRect, scale: CGFloat = 1) async -> UIImage? {
        guard let context = makeCGContext(size: rect.size, scale: scale),
              let markup = controller?.markup else {
            return nil
        }
        await markup.draw(in: context, frame: rect)
        guard let cgImage = context.makeImage() else {
            return nil
        }
        return UIImage(cgImage: cgImage)
    }
    
    func exportAsData() async -> Data? {
        do {
            return try await markup?.dataRepresentation()
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    /// Creating CGContext!
    private func makeCGContext(size: CGSize, scale: CGFloat) -> CGContext? {
        let width = Int(size.width * scale)
        let height = Int(size.height * scale)
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGImageAlphaInfo.premultipliedLast.rawValue
        
        guard let context = CGContext(data: nil,
                                      width: width,
                                      height: height,
                                      bitsPerComponent: 8,
                                      bytesPerRow: 0,
                                      space: colorSpace,
                                      bitmapInfo: bitmapInfo) else {
            return nil
        }
        context.scaleBy(x: scale, y: scale)
        context.translateBy(x: 0, y: size.height)
        context.scaleBy(x: 1, y: -1)
        return context
    }
}



/// Calculating center rect with the given rect!
extension NSAttributedString {
    func centerRect(int rect: CGRect) -> CGRect {
        let textSize = self.size()
        let textCenter = CGPoint(
            x: rect.midX - (textSize.width / 2),
            y: rect.midY - (textSize.height / 2)
        )
        
        return CGRect(
            origin: textCenter,
            size: textSize
        )
    }
}




