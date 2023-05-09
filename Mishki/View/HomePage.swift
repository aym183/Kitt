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
                                
                                //                                if let data = profileImage.data(using: .utf8), let image = UIImage(data: data) {
                                //                                    Image(uiImage: image)
                                //                                        .resizable()
                                //                                        .scaledToFill()
                                //                                        .frame(width: 80, height: 80)
                                //                                        .cornerRadius(50)
                                //                                } else {
                                Image(systemName: "person.circle").font(Font.system(size: 60))
                                //                                }
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
                                ForEach(0..<noOfLinks, id: \.self) { index in
                                    HStack {
                                        ZStack {
                                            HStack {
                                                RoundedRectangle(cornerRadius: 10).frame(width: geometry.size.width-150, height: 60).foregroundColor(.gray).opacity(0.2).padding(.leading, 10)
                                                Spacer()
                                            }
                                            
                                            HStack {
                                                Text( readData.links![index]["name"]!).foregroundColor(.black).font(Font.system(size: 15)).fontWeight(.medium).padding(.leading, 30)
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
                            .padding(.top, 10)
                            
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
                        readData.getLinks()
                        readData.getProducts()
                    }
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HomePage()
    }
}
