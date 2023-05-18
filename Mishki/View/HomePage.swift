//
//  ContentView.swift
//  Mishki
//
//  Created by Ayman Ali on 09/05/2023.
//

import SwiftUI

struct HomePage: View {
    @State var formShown = false
    @State var settingsShown = false
    @State var isShownHomePage: Bool
    @State var isShownProductCreated: Bool
    @State var isShownLinkCreated: Bool
    @AppStorage("username") var userName: String = ""
    @StateObject var readData = ReadDB()
    @State var oldProductName = ""
    @State var oldProductDesc = ""
    @State var oldProductPrice = ""
    @State var oldImage: UIImage?
    @State var productName = ""
    @State var productDesc = ""
    @State var productPrice = ""
    @State var image: UIImage?
    @State var oldName = ""
    @State var oldURL = ""
    @State var linkName = ""
    @State var linkURL = ""
    @State var linksNumber = 0
    @State var productsNumber = 0
    @State var productIndex = 0
    @State var linkIndex = 0
    @State var profile_image: UIImage?
    @State var productEditShown = false
    @State var linkEditShown = false

    
    var body: some View {
        var noOfLinks = readData.links?.count ?? 0
        var noOfProducts = readData.products?.count ?? 0
        GeometryReader { geometry in
                ZStack {
                    Color(.white).ignoresSafeArea()
                    
                    if isShownHomePage {
                        VStack {
                            ProgressView()
                                .scaleEffect(1.75)
                                .progressViewStyle(CircularProgressViewStyle(tint: Color.black))
                            
                            Text("Getting Mishki Ready! 🥳").font(Font.system(size: 20)).fontWeight(.semibold).multilineTextAlignment(.center).padding(.top, 30).padding(.horizontal).foregroundColor(.black)
                        }
                    }
                    
                    if isShownLinkCreated {
                        VStack {
                            ProgressView()
                                .scaleEffect(1.75)
                                .progressViewStyle(CircularProgressViewStyle(tint: Color.black))
                            
                            Text("Creating your link!").font(Font.system(size: 20)).fontWeight(.semibold).multilineTextAlignment(.center).padding(.top, 30).padding(.horizontal).foregroundColor(.black)
                        }
                    }
                    
                    if isShownProductCreated {
                        VStack {
                            ProgressView()
                                .scaleEffect(1.75)
                                .progressViewStyle(CircularProgressViewStyle(tint: Color.black))
                            
                            Text("Creating your product!").font(Font.system(size: 20)).fontWeight(.semibold).multilineTextAlignment(.center).padding(.top, 30).padding(.horizontal).foregroundColor(.black)
                        }
                    }
                    
                    
                    VStack {
                        HStack {
                            VStack(alignment: .leading) {
                                Text("kitt.bio/\(userName)").font(Font.system(size: 20)).fontWeight(.bold)
                                
                                HStack(spacing: 25) {
                                    Button(action: {}) {
                                        Image(systemName: "doc").background(
                                            Circle().fill(.gray).frame(width: 28, height: 28).opacity(0.2)
                                        )
                                    }
                                    
                                    Button(action: {}) {
                                        Image(systemName: "arrow.up.forward").background(
                                            Circle().fill(.gray).frame(width: 28, height: 28).opacity(0.2)
                                        )
                                    }
                                }
                                .font(Font.system(size: 13))
                                .padding(.leading, 10).padding(.top, 0.5)
                                .fontWeight(.bold)
                                
                            }
                            Spacer()
                            
                            Button(action: {settingsShown.toggle()}) {
                                
                                if profile_image != nil {
                                    Image(uiImage: profile_image!)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 80, height: 80)
                                        .cornerRadius(50)
                                } else {
                                    Image(systemName: "person.circle").font(Font.system(size: 60))
                                }
                            }
                        }
                        .padding(.horizontal, 10)
                        
                        HStack {
                            Button(action: {
                                linksNumber = noOfLinks
                                productsNumber = noOfProducts
                                formShown.toggle()
                            }) {
                                HStack(spacing: 6) {
                                    Image(systemName: "plus")
                                    Text("Add")
                                }
                                .frame(width: 85, height: 35).padding(4).background(.black).foregroundColor(.white).cornerRadius(10).font(Font.system(size: 20)).fontWeight(.heavy)
                            }
                            
                            Spacer()
                        }
                        .padding(.horizontal, 10).padding(.top)
                        
                        
                        Spacer()
                        
                        if readData.links == nil {
                            Text("No products or links added yet.").fontWeight(.semibold)
                            Spacer()
                        } else {
                            ScrollView(showsIndicators: false) {
//                                if readData.product_images != [] {
                                    ForEach(0..<noOfProducts, id: \.self) { index in
                                        HStack {
                                            ZStack {
                                                HStack {
                                                    RoundedRectangle(cornerRadius: 10).frame(width: geometry.size.width-150, height: 240).foregroundColor(.gray).opacity(0.2).padding(.leading, 10)
                                                    Spacer()
                                                }
                                                
                                                VStack {
                                                    Image(uiImage: readData.loadProductImage(key: readData.products![index]["image"]!)).resizable().frame(width: geometry.size.width-152, height: 160).cornerRadius(10).scaledToFit().padding(.trailing, 21)
                                                    
                                                    HStack {
                                                        VStack(alignment: .leading) {
                                                            Spacer()
                                                            Text( readData.products![index]["name"]!).font(Font.system(size: 15)).fontWeight(.medium)
                                                            
                                                            Text("\(readData.products![index]["price"]!) AED").font(Font.system(size: 15)).fontWeight(.heavy).padding(.top, -2)
                                                        }
                                                        .padding(.leading, 22).padding(.bottom, 5)
                                                        Spacer()
                                                    }
                                                }
                                                
                                                
                                            }
                                            .padding(.top,10)
                                            .multilineTextAlignment(.leading)
                                            
                                            HStack(spacing: 25) {
                                                Button(action: {
                                                    productName = readData.products![index]["name"]!
                                                    productDesc = readData.products![index]["description"]!
                                                    productPrice = "\(readData.products![index]["price"]!)"
                                                    oldProductName = readData.products![index]["name"]!
                                                    oldProductDesc = readData.products![index]["description"]!
                                                    oldProductPrice = "\(readData.products![index]["price"]!)"
                                                    oldImage = readData.loadProductImage(key: readData.products![index]["image"]!)
                                                    image = readData.loadProductImage(key: readData.products![index]["image"]!)
                                                    productEditShown.toggle()
                                                    
                                                }) {
                                                    Image(systemName: "pencil").background(
                                                        Circle().fill(.gray).frame(width: 28, height: 28).opacity(0.2)
                                                    )
                                                }
                                                
                                                Button(action: {
                                                    productIndex = index
                                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                                        DeleteDB().deleteProduct(image: readData.products![productIndex]["image"]!)
                                                        readData.products?.remove(at: productIndex)
                                                    }
                                                }) {
                                                    Image(systemName: "trash").background(
                                                        Circle().fill(.gray).frame(width: 28, height: 28).opacity(0.2)
                                                    ).foregroundColor(.red)
                                                }
                                            }
                                            .font(Font.system(size: 13))
                                            .padding(.top, 5).padding(.trailing)
                                            .fontWeight(.bold)
                                        }
                                        .id(index)
                                    }
                                    .padding(.top, 10)
                                    
//                                }
                                
                                
                                ForEach(0..<noOfLinks, id: \.self) { index in
                                    HStack {
                                        ZStack {
                                            HStack {
                                                RoundedRectangle(cornerRadius: 10).frame(width: geometry.size.width-150, height: 60).foregroundColor(.gray).opacity(0.2).padding(.leading, 10)
                                                Spacer()
                                            }
                                            
                                            HStack {
                                                Text( readData.links![index]["name"]!).foregroundColor(.black).font(Font.system(size: 15)).fontWeight(.medium).padding(.leading, 22)
                                                Spacer()
                                            }
                                        }
                                        .padding(.top,10)
                                        .multilineTextAlignment(.leading)
                                        
                                        HStack(spacing: 25) {
                                            Button(action: {
                                                linkName = readData.links![index]["name"]!
                                                linkURL = readData.links![index]["url"]!
                                                oldName = readData.links![index]["name"]!
                                                oldURL = readData.links![index]["url"]!
                                                linkEditShown.toggle()
                                                
                                            }) {
                                                Image(systemName: "pencil").background(
                                                    Circle().fill(.gray).frame(width: 28, height: 28).opacity(0.2)
                                                )
                                            }
                                            
                                            Button(action: {
                                                linkIndex = index
                                                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                                    DeleteDB().deleteLink(name: readData.links![index]["name"]!, url: readData.links![index]["url"]!)
                                                        readData.links?.remove(at: linkIndex as Int)
                                                }
                                            }) {
                                                Image(systemName: "trash").background(
                                                    Circle().fill(.gray).frame(width: 28, height: 28).opacity(0.2)
                                                ).foregroundColor(.red)
                                            }
                                        }
                                        .font(Font.system(size: 13))
                                        .padding(.top, 5).padding(.trailing)
                                        .fontWeight(.bold)
                                    }
                                    .id(index)
                                }
                            }
                            .padding(.top)
                        }
                    }
                    .frame(width: geometry.size.width-40, height: geometry.size.height-20)
                    .navigationDestination(isPresented: $formShown) {
                        FormSelection(links_number: linksNumber, products_number: productsNumber, readData: readData)
                    }
                    .navigationDestination(isPresented: $settingsShown) {
                        SettingsPage()
                    }
                    .foregroundColor(.black)
                    .padding(.top, 30)
                    .onAppear {
                        print("I AM HERE")
                        DispatchQueue.global(qos: .userInteractive).async {
                            readData.getLinks()
                            readData.getProducts()
                            readData.loadProfileImage() { response in
                                if response != nil {
                                    profile_image = response!
                                }
                            }
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                withAnimation(.easeOut(duration: 0.5)) {
                                    isShownHomePage = false
                                    isShownLinkCreated = false
                                }
                            }
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                withAnimation(.easeOut(duration: 0.5)) {
                                    isShownProductCreated = false
                                }
                            }
                        }
                    }
                    .opacity(isShownHomePage ? 0 : 1)
                    .opacity(isShownProductCreated ? 0 : 1)
                    .opacity(isShownLinkCreated ? 0 : 1)
                }
                .navigationDestination(isPresented: $productEditShown) {
                    ProductForm(oldProductName: $oldProductName, oldProductDesc: $oldProductDesc, oldProductPrice: $oldProductPrice, oldImage: $oldImage, productName: $productName, productDesc: $productDesc, productPrice: $productPrice, image: $image, products_number: productsNumber, ifEdit: true, readData: readData).presentationDetents([.height(800)])
                }
                .sheet(isPresented: $linkEditShown) {
                    LinkForm(oldName: $oldName, oldURL: $oldURL, linkName: $linkName, linkURL: $linkURL, ifEdit: true, links_number: linksNumber, linkEditShown: $linkEditShown, readData: readData).presentationDetents([.height(500)])
                }
        }
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        HomePage()
//    }
//}
