//  ContentView.swift
//  Draw!
//
//  Created by TrungAnhx on 11/3/26.
//

import SwiftUI
import PaperKit
import PhotosUI

struct ContentView: View {
    @State private var data = EditorData()
    @State private var showTools: Bool = false
    @State private var showImagePicker: Bool = false
    @State private var photoItem: PhotosPickerItem?
    
    var body: some View {
        NavigationStack {
            EditorView(size: .init(width: 350, height: 670), data: data)
                .toolbar {
                    MenuItems()
                    
                    Menu("Export", systemImage: "square.and.arrow.up.fill") {
                        Button("As Image") {
                            Task {
                                let rect = CGRect(origin: .zero, size: .init(width: 350, height: 670))
                                if let image = await data.exportAsImage(rect, scale: 2) {
                                    /// Saving Image
                                    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                                }
                            }
                        }
                        
                        Button("As Data") {
                            Task {
                                if let markupData = await data.exportAsData() {
                                    print(markupData)
                                }
                            }
                        }
                    }
                }
        }
        .photosPicker(isPresented: $showImagePicker, selection: $photoItem)
        .onChange(of: photoItem) { oldValue, newValue in
            guard let newValue else { return }
            Task {
                guard let data = try? await newValue.loadTransferable(type: Data.self),
                      let image = UIImage(data: data) else {
                    return
                }
                
                self.data.insertImage(image, rect: .init(origin: .zero, size: .init(width: 100, height: 100)))
                photoItem = nil
            }
        }
    }
    
    @ViewBuilder
    func MenuItems() -> some View {
        Menu("Items") {
            Button("Text") {
                data.insertText(.init("Savagers"), rect: .zero)
            }
            
            Menu("Shapes") {
                let rect = CGRect(origin: .zero, size: .init(width: 100, height: 100))
                
                Button("Rectangle") {
                    let configuration = ShapeConfiguration(type: .rectangle, fillColor: UIColor.blue.cgColor)
                    data.insertShape(configuration, rect: rect)
                }
                
                Button("Star") {
                    let configuration = ShapeConfiguration(type: .star, fillColor: UIColor.blue.cgColor)
                    data.insertShape(configuration, rect: rect)
                }
            }
            
            Button("Image") {
                showImagePicker.toggle()
            }
            
            Button(showTools ? "Hide Tools" : "Show Tools") {
                showTools.toggle()
                data.showPencilKitTools(showTools)
            }
        }
    }
}


