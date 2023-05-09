//
//  ContentView.swift
//  Mishki
//
//  Created by Ayman Ali on 09/05/2023.
//

import SwiftUI

struct HomePage: View {
    @State var productsListed = false
    @State var formShown = false
    @State var settingsShown = false
    @AppStorage("profile_image") var profileImage: String = ""
    @AppStorage("username") var userName: String = ""
    var body: some View {
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
                            Button(action: { formShown.toggle() }) {
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
                        
                        if !productsListed {
                            Text("No products or links added yet.").fontWeight(.semibold)
                            Spacer()
                        } else {
                            ScrollView {
                                Text("No products.").fontWeight(.semibold)
                                Spacer()
                            }
                            .border(.black, width: 2).padding(.top)
                            
                        }
                    }
                    .frame(width: geometry.size.width-40, height: geometry.size.height-20)
                    .navigationDestination(isPresented: $formShown) {
                        FormSelection()
                    }
                    .navigationDestination(isPresented: $settingsShown) {
                        SettingsPage()
                    }
                    .foregroundColor(.black)
                    .padding(.top, 30)
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HomePage()
    }
}
