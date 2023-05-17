//
//  ProductForm.swift
//  Mishki
//
//  Created by Ayman Ali on 09/05/2023.
//

import SwiftUI

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
    var products_number: Int
    @State var ifEdit: Bool
    @ObservedObject var readData: ReadDB
    
    var body: some View {
        GeometryReader { geometry in
                ZStack {
                    Color(.white).ignoresSafeArea()
                    VStack {
                        HStack {
                            if ifEdit {
                                Text("Edit Product").font(.system(size: min(geometry.size.width, geometry.size.height) * 0.06)).fontWeight(.semibold).multilineTextAlignment(.leading).padding(.vertical)
                            } else {
                                Text("New Product").font(.system(size: min(geometry.size.width, geometry.size.height) * 0.06)).fontWeight(.semibold).multilineTextAlignment(.leading).padding(.vertical)
                            }
                            
                            Spacer()
                        }
                        .padding(.leading, 15).padding(.bottom, -5).padding(.top, -10)
                        
                        Button(action: { showImagePicker.toggle() }) {
                            ZStack {
                                if let image = self.image {
                                    Image(uiImage: image)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: geometry.size.width-70, height: geometry.size.height - 500)
                                        .cornerRadius(10)
                                } else {
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(.gray)
                                        .opacity(0.2)
                                        .frame(width: geometry.size.width-70, height: geometry.size.height - 500)
                                    
                                    VStack {
                                        Image(systemName: "plus").font(.system(size: min(geometry.size.width, geometry.size.height) * 0.1)).fontWeight(.semibold)
                                        Text("Add cover image").padding(.top,5).fontWeight(.semibold)
                                    }
                                    .opacity(0.5)
                                }
                            }
                            
                        }
                        
                        TextField("", text: $productName, prompt: Text("Product Name").foregroundColor(.black)).padding().frame(width: geometry.size.width-70, height: 60).foregroundColor(.black).background(.gray).opacity(0.2).cornerRadius(10).padding(.top).disableAutocorrection(true).autocapitalization(.none)
                        
                        TextField("", text: $productDesc, prompt: Text("Product Description").foregroundColor(.black)).padding().frame(width: geometry.size.width-70, height: 60).foregroundColor(.black).background(.gray).opacity(0.2).cornerRadius(10).padding(.top, 10).disableAutocorrection(true).autocapitalization(.none)
                        
                        TextField("", text: $productPrice, prompt: Text("Price (AED)").foregroundColor(.black)).padding().frame(width: geometry.size.width-70, height: 60).foregroundColor(.black).background(.gray).opacity(0.2).cornerRadius(10).padding(.top,10).disableAutocorrection(true).autocapitalization(.none)
                        
//                        Button(action: {}) {
//                            ZStack {
//                                RoundedRectangle(cornerRadius: 10)
//                                    .fill(.gray)
//                                    .opacity(0.2)
//                                    .frame(height: 60)
//                                    .padding(.top,10)
//                                HStack {
//                                    Image(systemName: "plus")
//                                    Text("Upload File")
//                                    Spacer()
//                                }
//                                .font(.system(size: min(geometry.size.width, geometry.size.height) * 0.04))
//                                .fontWeight(.semibold)
//                                .padding(.leading).padding(.top, 5)
//                            }
//                            .frame(width: geometry.size.width-70)
//                        }
                        
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
                                    if products_number != 0 {
                                        if let image = self.image {
                                            UpdateDB().updateProducts(image: image, name: productName, description: productDesc, price: productPrice)
                                        }
                                    } else {
                                        if let image = self.image {
                                            CreateDB().addProducts(image: image, name: productName, description: productDesc, price: productPrice)
                                        }
                                    }
                                    productCreated.toggle()
                                }
                            }
                        }) {
                            if ifEdit {
                                Text("Update").font(.system(size: min(geometry.size.width, geometry.size.height) * 0.06)).frame(width: geometry.size.width-70, height: 60).background(.black).foregroundColor(.white).cornerRadius(10).font(Font.system(size: 20)).fontWeight(.heavy)
                            } else {
                                Text("Add").font(.system(size: min(geometry.size.width, geometry.size.height) * 0.06)).frame(width: geometry.size.width-70, height: 60).background(.black).foregroundColor(.white).cornerRadius(10).font(Font.system(size: 20)).fontWeight(.heavy)
                            }
                        }
                        .padding(.bottom)
                        
                    }
                    .frame(width: geometry.size.width-40, height: geometry.size.height-20)
                    }
                    .foregroundColor(.black)
                    .sheet(isPresented: $showImagePicker) {
                        ImagePicker(image: $image)
                    }
                    .navigationDestination(isPresented: $productCreated) {
                        HomePage(isShownHomePage: false, isShownProductCreated: true, isShownLinkCreated: false).navigationBarHidden(true)
                    }
            }
    }
}

//struct ProductForm_Previews: PreviewProvider {
//    static var previews: some View {
//        ProductForm()
//    }
//}
