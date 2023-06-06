//
//  ProductForm.swift
//  Mishki
//
//  Created by Ayman Ali on 09/05/2023.
//

import SwiftUI
import MobileCoreServices
import UniformTypeIdentifiers
import UIKit

struct ProductForm: View {
    @Binding var oldProductName: String
    @Binding var oldProductDesc: String
    @Binding var oldProductPrice: String
    @Binding var oldImage: UIImage?
    @Binding var productName: String
    @Binding var productDesc: String
    @Binding var productPrice: String
    @Binding var image: UIImage?
    @State var isShowingHint = false
    @State var charLimit = false
    @State var uploadFile = ""
    @State var showImagePicker = false
    @State var productCreated = false
    @State var productDeleted = false
    @State var document_picker_bool = false
    var products_number: Int
    @State var ifEdit: Bool
    @State var productIndex: Int?
    @ObservedObject var readData: ReadDB
    @State var selectedPDF: URL?
    var areAllFieldsEmpty: Bool {
        if ifEdit {
            return productName.isEmpty || productDesc.isEmpty || productPrice.isEmpty || image == nil
        } else {
            return productName.isEmpty || productDesc.isEmpty || productPrice.isEmpty || image == nil || selectedPDF == nil
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
                ZStack {
                    Color(.white).ignoresSafeArea()
                    ScrollView(showsIndicators: false) {
                        VStack {
                            HStack() {
                                if ifEdit {
                                    Text("Edit Product").font(Font.custom("Avenir-Heavy", size: min(geometry.size.width, geometry.size.height) * 0.06)).fontWeight(.bold).multilineTextAlignment(.leading).padding(.vertical)

                                    Spacer()

                                    Button(action: {
                                        DispatchQueue.global(qos: .userInteractive).async {
                                            DeleteDB().deleteProduct(image: readData.products![productIndex!]["image"]!) { response in
                                                if response == "Deleted" {
                                                    readData.products?.remove(at: productIndex!)
                                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                                        productDeleted.toggle()
                                                    }
                                                }
                                            }
                                        }
                                    }) {
                                        Image(systemName: "trash").font(.system(size: 25)).background(Circle().fill(.gray).frame(width: 45, height: 45).opacity(0.3)).foregroundColor(.red).fontWeight(.bold).padding(.trailing, 25).padding(.vertical)

//                                        Image(systemName: "trash").background(Circle().fill(.gray).frame(width: 40, height: 40).opacity(0.3)).foregroundColor(.red).fontWeight(.bold).padding(.trailing, 30).padding(.vertical)
                                    }
                                } else {
                                    Text("New Product").font(Font.custom("Avenir-Heavy", size: min(geometry.size.width, geometry.size.height) * 0.06)).fontWeight(.bold).padding(.vertical).multilineTextAlignment(.leading)
                                    
                                    Button(action: {
                                        withAnimation(.easeOut(duration: 0.5)) {
                                                isShowingHint.toggle()
                                        }
                                        }) {
                                        Image(systemName: "questionmark")
                                            .background(Circle().fill(.gray).font(.system(size: 10)).frame(width: 25, height: 25).opacity(0.3))
                                            .foregroundColor(.black).fontWeight(.bold).padding(.vertical)
                                            .fontWeight(.semibold).padding(.leading, 10).padding(.top, -3)
                                    }
                                    
                                    Spacer()
                                }
                            }
                            .padding(.leading, 15).padding(.bottom, -5).padding(.top, -5)
                            
                            if isShowingHint {
                                ProductCardView(hint: "Please upload product images taken in landscape for optimal appearance")
                                    .transition(.scale)
                                    .padding(.top, -18)
                                    .padding(.leading, 150)
                                    .padding(.bottom, 5)
    //                                .cornerRadius(10, corners: [.topRight, .bottomRight, .bottomLeft])
                            }
                            
                            
                            ZStack {
                                if let image = self.image {
                                    ZStack {
                                        Image(uiImage: image)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: geometry.size.width-70, height: geometry.size.height - 450)
                                        
                                        VStack {
                                            HStack {
                                                Spacer()
                                                Button(action: { showImagePicker.toggle() }) {
                                                    Image(systemName: "pencil").background(Circle().fill(.white).frame(width: 28, height: 28).opacity(0.8)).padding(.trailing).padding(.top).fontWeight(.bold)
                                                }
                                            }
                                            Spacer()
                                        }
                                        .frame(height: geometry.size.height - 450)
                                        
                                    }
                                    .frame(width: geometry.size.width-70, height: geometry.size.height - 450)
                                    .cornerRadius(10)
                                } else {
                                    Button(action: { showImagePicker.toggle() }) {
                                        ZStack {
                                            
                                            RoundedRectangle(cornerRadius: 10)
                                                .fill(Color("TextField"))
                                                .frame(width: geometry.size.width-70, height: geometry.size.height - 450)
                                            
                                            VStack {
                                                Image(systemName: "plus").font(.system(size: min(geometry.size.width, geometry.size.height) * 0.1)).fontWeight(.semibold)
                                                Text("Add cover image").font(Font.custom("Avenir-Black", size: 16))
                                            }
                                            .foregroundColor(.gray)
                                        }
                                    }
                                }
                                //                            }
                                
                            }
                            
                            ZStack {
                                TextField("", text: $productName, prompt: Text("Product Name").foregroundColor(.gray).font(Font.custom("Avenir-Black", size: 16))).padding().padding(.trailing, 30).frame(width: geometry.size.width-70, height: 60).foregroundColor(.black).background(Color("TextField")).cornerRadius(10).disableAutocorrection(true).autocapitalization(.none).font(Font.custom("Avenir-Medium", size: 16))
                                        .onChange(of: self.productName, perform: { value in
                                               if value.count > 55 {
                                                   self.productName = String(value.prefix(55))
                                               }
                                          })
                                
                                if productName.count > 0 {
                                    HStack {
                                        Spacer()
                                        
                                        if productName.count >= 45 {
                                            Text("\(55 - productName.count)")
                                                .foregroundColor(.red)
                                                .font(Font.custom("Avenir-Medium", size: min(geometry.size.width, geometry.size.height) * 0.035))
                                                .fontWeight(.bold)
                                        } else {
                                            Text("\(55 - productName.count)")
                                                .foregroundColor(.black)
                                                .font(Font.custom("Avenir-Medium", size: min(geometry.size.width, geometry.size.height) * 0.035))
                                                .fontWeight(.bold)
                                        }
                                    }
                                    .padding(.trailing, 30)
                            }
                            }
                            
                            ZStack(alignment: .topLeading) {
                                
                                TextEditor(text: $productDesc)
                                    .padding([.horizontal, .bottom], 12).padding(.top, 5)
                                    .frame(width: geometry.size.width-70, height: 140)
                                    .scrollContentBackground(.hidden)
                                    .background(Color("TextField"))
                                    .cornerRadius(10)
                                    .disableAutocorrection(true)
                                    .autocapitalization(.none)
                                    .font(Font.custom("Avenir-Medium", size: 16))
                                
                                if productDesc.count == 0 {
                                    Text("Product Description")
                                        .foregroundColor(.gray)
                                        .font(Font.custom("Avenir-Black", size: 16))
                                        .padding([.top, .leading])
                                }
                            }
                            .padding(.bottom, 5)
                            
                            
                                //                                .font(Font.custom("Avenir-Medium", size: 16))
                                //                                    .focused($productDesc, equals: true)
                                
//                            TextField("", text: $productDesc, prompt:Text("Product Description").foregroundColor(.gray).font(Font.custom("Avenir-Black", size: 16)), axis: .vertical).padding(.top, -55).padding(.horizontal).frame(width: geometry.size.width-70, height: 140).foregroundColor(.black).background(Color("TextField")).cornerRadius(10).disableAutocorrection(true).autocapitalization(.none)
//                                .font(Font.custom("Avenir-Medium", size: 16))
//                                    .focused($productDesc, equals: true)
                            
                            if ifEdit {
                                TextField("", text: $productPrice, prompt: Text("Price (AED)").foregroundColor(.gray).font(Font.custom("Avenir-Black", size: 16))).padding().frame(width: geometry.size.width-70, height: 60).foregroundColor(.black).background(Color("TextField")).cornerRadius(10).disableAutocorrection(true).autocapitalization(.none).font(Font.custom("Avenir-Medium", size: 16)).keyboardType(.decimalPad)
                            } else {
                                TextField("", text: $productPrice, prompt: Text("Price (AED)").foregroundColor(.gray).font(Font.custom("Avenir-Black", size: 16))).padding().frame(width: geometry.size.width-70, height: 60).foregroundColor(.black).background(Color("TextField")).cornerRadius(10).disableAutocorrection(true).autocapitalization(.none).font(Font.custom("Avenir-Medium", size: 16)).keyboardType(.decimalPad).padding(.top, -5)
                            }
                            
                            if !ifEdit {
                                Button(action: {
                                    document_picker_bool.toggle()
                                }) {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(Color("TextField"))
                                            .frame(height: 60)
                                            .padding(.bottom, 5)
                                        HStack {
                                            if let url = selectedPDF {
                                                let filename = url.lastPathComponent
                                                Text(filename).font(Font.custom("Avenir-Medium", size: 16))
                                            } else {
                                                Image(systemName: "plus").font(.system(size: min(geometry.size.width, geometry.size.height) * 0.05)).fontWeight(.heavy).foregroundColor(.gray)
                                                Text("Upload PDF").font(Font.custom("Avenir-Black", size: 16)).foregroundColor(.gray).fontWeight(.black)
                                            }
                                            Spacer()
                                        }
                                        .font(.system(size: min(geometry.size.width, geometry.size.height) * 0.04))
                                        .fontWeight(.semibold)
                                        .padding(.leading)
                                    }
                                    .frame(width: geometry.size.width-70)
                                }
                            }
                            
                            Spacer()
                            
                            Button(action: {
                                if ifEdit {
                                    DispatchQueue.global(qos: .userInteractive).async {
                                        if let image = self.image {
                                            UpdateDB().updateCreatedProduct(data: ["oldProductName": oldProductName, "oldProductDesc": oldProductDesc, "oldProductPrice": oldProductPrice, "productName": productName, "productDesc": productDesc, "productPrice": productPrice], old_image: oldImage!, new_image: image) { response in
                                                if response == "Successful" {
                                                    productCreated.toggle()
                                                }
                                            }
                                        }
                                    }
                                } else {
                                    DispatchQueue.global(qos: .userInteractive).async {
                                        if products_number != 0, let pdf = selectedPDF {
                                            if let image = self.image {
                                                UpdateDB().updateProducts(image: image, name: productName, description: productDesc, price: productPrice, file: pdf)
                                            }
                                        } else {
                                            if let image = self.image, let pdf = selectedPDF {
                                                CreateDB().addProducts(image: image, name: productName, description: productDesc, price: productPrice, file: pdf)
                                            }
                                        }
                                        productCreated.toggle()
                                    }
                                }
                            }) {
                                if ifEdit {
                                    Text("Update").font(Font.custom("Avenir-Black", size: min(geometry.size.width, geometry.size.height) * 0.06)).frame(width: geometry.size.width-70, height: 60).background(areAllFieldsEmpty ? Color.gray : Color.black).foregroundColor(areAllFieldsEmpty ? Color.black : Color.white).cornerRadius(10)
                                } else {
                                    Text("Add").font(Font.custom("Avenir-Black", size: min(geometry.size.width, geometry.size.height) * 0.06)).frame(width: geometry.size.width-70, height: 60).background(areAllFieldsEmpty ? Color.gray : Color.black).foregroundColor(areAllFieldsEmpty ? Color.black : Color.white).cornerRadius(10)
                                }
                            }
                            .padding(.bottom)
                            .disabled(areAllFieldsEmpty)
                        }
                        
                    }
                    .padding(.top, -5)
                    .frame(width: geometry.size.width-40, height: geometry.size.height-20)
                    }
                    .onAppear {
                        if !ifEdit {
                            productName = ""
                            productDesc = ""
                            image = nil
                            selectedPDF = nil
                        }
                    }
                    .foregroundColor(.black)
                    .sheet(isPresented: $showImagePicker) {
                        ImagePicker(image: $image)
                    }
                    .sheet(isPresented: $document_picker_bool) {
                        DocumentPicker(selectedURL: $selectedPDF)
                    }
                    .navigationDestination(isPresented: $productCreated) {
                        HomePage(isShownHomePage: false, isChangesMade: false, isShownClassCreated: false, isShownProductCreated: true, isShownLinkCreated: false).navigationBarHidden(true)
                    }
                    .navigationDestination(isPresented: $productDeleted) {
                        HomePage(isShownHomePage: false, isChangesMade: true, isShownClassCreated: false, isShownProductCreated: false, isShownLinkCreated: false).navigationBarHidden(true)
                    }
            }
    }
}

struct DocumentPicker: UIViewControllerRepresentable {
    
        @Binding var selectedURL: URL?
    
        func makeCoordinator() -> DocumentPicker.Coordinator {
            Coordinator(selectedURL: $selectedURL)
        }
        
        func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
            let picker = UIDocumentPickerViewController(forOpeningContentTypes: [.data], asCopy: true)
            picker.allowsMultipleSelection = false
            picker.delegate = context.coordinator
            return picker
        }
        
        func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {
            // No update needed
        }
        
        class Coordinator: NSObject, UIDocumentPickerDelegate {
            
            @Binding var selectedURL: URL?
            
            init(selectedURL: Binding<URL?>) {
                _selectedURL = selectedURL
            }
            
            func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
                if let url = urls.first {
                    selectedURL = url
                }
            }
        }
}

struct ProductCardView: View {
    let hint: String
    
    var body: some View {
        RoundedRectangle(cornerRadius: 10)
            .fill(Color("TextField"))
            .foregroundColor(.white)
            .frame(width: 165, height: 70)
            .overlay(Text(hint).foregroundColor(.black).font(Font.custom("Avenir-Medium", size: 12)).padding(10))
    }
}
