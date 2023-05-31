//
//  ProductForm.swift
//  Mishki
//
//  Created by Ayman Ali on 09/05/2023.
//

import SwiftUI
import MobileCoreServices
import UniformTypeIdentifiers

struct ProductForm: View {
    @Binding var oldProductName: String
    @Binding var oldProductDesc: String
    @Binding var oldProductPrice: String
    @Binding var oldImage: UIImage?
    @Binding var productName: String
    @Binding var productDesc: String
    @Binding var productPrice: String
    @Binding var image: UIImage?
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
    
    var body: some View {
        GeometryReader { geometry in
                ZStack {
                    Color(.white).ignoresSafeArea()
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
                                    Image(systemName: "trash").background(Circle().fill(.gray).frame(width: 30, height: 30).opacity(0.3)).foregroundColor(.red).fontWeight(.bold).padding(.trailing, 25).padding(.vertical)
                                }
                            } else {
                                Text("New Product").font(Font.custom("Avenir-Heavy", size: min(geometry.size.width, geometry.size.height) * 0.06)).fontWeight(.bold).padding(.vertical).multilineTextAlignment(.leading)
//
                                Spacer()
                            }
                        }
                        .padding(.leading, 15).padding(.bottom, -5).padding(.top, -5)
                        
                       
                            ZStack {
                                if let image = self.image {
                                    ZStack {
                                        Image(uiImage: image)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: geometry.size.width-70, height: geometry.size.height - 500)
                                            .cornerRadius(10)

                                        VStack {
                                            HStack {
                                                Spacer()
                                                Button(action: { showImagePicker.toggle() }) {
                                                    Image(systemName: "pencil").background(Circle().fill(.white).frame(width: 28, height: 28).opacity(0.8)).padding(.trailing, 30).padding(.top, 50).fontWeight(.bold)
                                                }
                                            }
                                            Spacer()
                                        }

                                    }
                                } else {
                                    Button(action: { showImagePicker.toggle() }) {
                                        ZStack {
                                            
                                                RoundedRectangle(cornerRadius: 10)
                                                    .fill(Color("TextField"))
                                                    .frame(width: geometry.size.width-70, height: geometry.size.height - 500)
                                                
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
                        
                        TextField("", text: $productName, prompt: Text("Product Name").foregroundColor(.gray).font(Font.custom("Avenir-Black", size: 16))).padding().frame(width: geometry.size.width-70, height: 60).foregroundColor(.black).background(Color("TextField")).cornerRadius(10).disableAutocorrection(true).autocapitalization(.none)
                        
                        TextField("", text: $productDesc, prompt:Text("Product Description").foregroundColor(.gray).font(Font.custom("Avenir-Black", size: 16)), axis: .vertical).padding(.top, -55).padding(.horizontal).frame(width: geometry.size.width-70, height: 140).foregroundColor(.black).background(Color("TextField")).cornerRadius(10).disableAutocorrection(true).autocapitalization(.none)
                        
                        TextField("", text: $productPrice, prompt: Text("Price (AED)").foregroundColor(.gray).font(Font.custom("Avenir-Black", size: 16))).padding().frame(width: geometry.size.width-70, height: 60).foregroundColor(.black).background(Color("TextField")).cornerRadius(10).disableAutocorrection(true).autocapitalization(.none)
                        
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
                                            Text(filename)
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
                                Text("Update").font(Font.custom("Avenir-Heavy", size: min(geometry.size.width, geometry.size.height) * 0.06)).fontWeight(.black).frame(width: geometry.size.width-70, height: 60).background(.black).foregroundColor(.white).cornerRadius(10)
                            } else {
                                Text("Add").font(Font.custom("Avenir-Heavy", size: min(geometry.size.width, geometry.size.height) * 0.06)).fontWeight(.black).frame(width: geometry.size.width-70, height: 60).background(.black).foregroundColor(.white).cornerRadius(10)
                            }
                        }
                        .padding(.bottom)
                        
                    }
                    .padding(.top, -5)
                    .frame(width: geometry.size.width-40, height: geometry.size.height-20)
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
                        HomePage(isShownHomePage: false, isChangesMade: false, isShownClassCreated: false, isShownProductCreated: false, isShownLinkCreated: false).navigationBarHidden(true)
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
