//
//  ProductForm.swift
//  Mishki
//
//  Created by Ayman Ali on 09/05/2023.
//

import SwiftUI

struct ProductForm: View {
    @State var productName = ""
    @State var productDesc = ""
    @State var productPrice = ""
    @State var uploadFile = ""
    
    var body: some View {
        GeometryReader { geometry in
            NavigationStack {
                ZStack {
                    Color(.white).ignoresSafeArea()
                    VStack {
                        HStack {
                            Text("New Product").font(.system(size: min(geometry.size.width, geometry.size.height) * 0.06)).fontWeight(.semibold).multilineTextAlignment(.leading).padding(.vertical).kerning(1.5)
                            
                            Spacer()
                        }
                        .padding(.leading, 15).padding(.bottom, -5)
                        
                        Button(action: {}) {
                            ZStack {
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
                        
                        TextField("", text: $productName, prompt: Text("Product Name").foregroundColor(.black)).padding().frame(width: geometry.size.width-70, height: 60).foregroundColor(.black).background(.gray).opacity(0.2).cornerRadius(10).padding(.top)
                        
                        TextField("", text: $productDesc, prompt: Text("Product Description").foregroundColor(.black)).padding().frame(width: geometry.size.width-70, height: 60).foregroundColor(.black).background(.gray).opacity(0.2).cornerRadius(10).padding(.top, 10)
                        
                        TextField("", text: $productPrice, prompt: Text("Price (AED)").foregroundColor(.black)).padding().frame(width: geometry.size.width-70, height: 60).foregroundColor(.black).background(.gray).opacity(0.2).cornerRadius(10).padding(.top,10)
                        
                        Button(action: {}) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(.gray)
                                    .opacity(0.2)
                                    .frame(height: geometry.size.height - 780)
                                    .padding(.top,10)
                                HStack {
                                    Image(systemName: "plus")
                                    Text("Upload File")
                                    Spacer()
                                }
                                .font(.system(size: min(geometry.size.width, geometry.size.height) * 0.04))
                                .fontWeight(.semibold)
                                .padding(.leading).padding(.top, 5)
                            }
                            .frame(width: geometry.size.width-70)
                        }
                        
                        Spacer()
                        
                        Button(action: {}) {
                            Text("Add").font(.system(size: min(geometry.size.width, geometry.size.height) * 0.06)).frame(width: geometry.size.width-70, height: 60).background(.black).foregroundColor(.white).cornerRadius(10).font(Font.system(size: 20)).fontWeight(.heavy)
                        }
                        .padding(.bottom)
                        
                        
                        
                    }
                    .frame(width: geometry.size.width-40, height: geometry.size.height-20)
                    }
               
                    .foregroundColor(.black)
                }
            }
    }
}

struct ProductForm_Previews: PreviewProvider {
    static var previews: some View {
        ProductForm()
    }
}
