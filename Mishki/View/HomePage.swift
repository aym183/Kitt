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
    @AppStorage("profile_image") var profileImage: String = ""
    @AppStorage("username") var userName: String = ""
    @StateObject var readData = ReadDB()
    @State var linksNumber = 0
    @State var productsNumber = 0
    
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
                    
                    
                    VStack {
                        HStack {
                            VStack(alignment: .leading) {
                                Text("mishki.shop/\(userName)").font(Font.system(size: 20)).fontWeight(.bold)
                                
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
                                
                                if readData.profile_image != nil {
                                    Image(uiImage: readData.profile_image!)
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
                            ScrollView {
                                if readData.product_images != [] {
                                    ForEach(0..<noOfProducts, id: \.self) { index in
                                        HStack {
                                            ZStack {
                                                HStack {
                                                    RoundedRectangle(cornerRadius: 10).frame(width: geometry.size.width-150, height: 240).foregroundColor(.gray).opacity(0.2).padding(.leading, 10)
                                                    Spacer()
                                                }
                                                
                                                VStack {
                                                    Image(uiImage: readData.product_images[index]!).resizable().frame(width: geometry.size.width-152, height: 160).cornerRadius(10).scaledToFit().padding(.trailing, 21)
                                                    
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
                                            .id(index)
                                            .multilineTextAlignment(.leading)
                                            
                                            HStack(spacing: 25) {
                                                Button(action: {}) {
                                                    Image(systemName: "pencil").background(
                                                        Circle().fill(.gray).frame(width: 28, height: 28).opacity(0.2)
                                                    )
                                                }
                                                
                                                Button(action: {}) {
                                                    Image(systemName: "trash").background(
                                                        Circle().fill(.gray).frame(width: 28, height: 28).opacity(0.2)
                                                    )
                                                }
                                            }
                                            .font(Font.system(size: 13))
                                            .padding(.top, 5).padding(.trailing)
                                            .fontWeight(.bold)
                                        }
                                    }
                                    .padding(.top, 10)
                                    
                                }
                                
                                
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
                                        .id(index)
                                        .multilineTextAlignment(.leading)
                                        
                                        HStack(spacing: 25) {
                                            Button(action: {}) {
                                                Image(systemName: "pencil").background(
                                                    Circle().fill(.gray).frame(width: 28, height: 28).opacity(0.2)
                                                )
                                            }
                                            
                                            Button(action: {}) {
                                                Image(systemName: "trash").background(
                                                    Circle().fill(.gray).frame(width: 28, height: 28).opacity(0.2)
                                                )
                                            }
                                        }
                                        .font(Font.system(size: 13))
                                        .padding(.top, 5).padding(.trailing)
                                        .fontWeight(.bold)
                                    }
                                }
                            }
                            
                            
                        }
                    }
                    .frame(width: geometry.size.width-40, height: geometry.size.height-20)
                    .navigationDestination(isPresented: $formShown) {
                        FormSelection(links_number: linksNumber, products_number: productsNumber)
                    }
                    .navigationDestination(isPresented: $settingsShown) {
                        SettingsPage()
                    }
                    .foregroundColor(.black)
                    .padding(.top, 30)
                    .onAppear {
                        DispatchQueue.global(qos: .userInteractive).async {
                            readData.getProfileImage()
                            readData.getLinks()
                            readData.getProducts()
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
                                print(readData.products)
                                print(readData.product_images)
                            }
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                withAnimation(.easeOut(duration: 0.5)) {
                                    isShownHomePage = false
                                }
                            }
                        }
                    }
                    .opacity(isShownHomePage ? 0 : 1)
                }
        }
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        HomePage()
//    }
//}
