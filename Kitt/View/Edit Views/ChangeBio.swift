//
//  ChangeBio.swift
//  Mishki
//
//  Created by Ayman Ali on 18/05/2023.
//

import SwiftUI

struct ChangeBio: View {
    @State var bio = ""
    @State var profileBioChanged = false
    @AppStorage("bio") var bioText: String = ""
    
    var body: some View {
        GeometryReader { geometry in
                ZStack {
                    Color(.white).ignoresSafeArea()
                    VStack{
                        HStack {
                            Text("Change Bio").font(Font.custom("Avenir-Heavy", size: min(geometry.size.width, geometry.size.height) * 0.06)).fontWeight(.bold).multilineTextAlignment(.leading).padding(.vertical).padding(.leading)
                            
                            Spacer()
                            }
                            
                        
                        ZStack {
                            TextField("", text: $bio, prompt: Text("Bio").foregroundColor(.gray).font(Font.custom("Avenir-Black", size: 16))).padding().padding(.trailing, 30).frame(width: geometry.size.width-70, height: 60).foregroundColor(.black).background(Color("TextField")).cornerRadius(10).disableAutocorrection(true).autocapitalization(.none).font(Font.custom("Avenir-Medium", size: 16))
                                .onChange(of: self.bio, perform: { value in
                                       if value.count > 50 {
                                           self.bio = String(value.prefix(50))
                                      }
                                  })
                            
                            if bio.count > 0 {
                                HStack {
                                    Spacer()
                                    
                                    if bio.count > 40 {
                                        Text("\(bio.count)")
                                            .foregroundColor(.red)
                                            .font(Font.custom("Avenir-Medium", size: min(geometry.size.width, geometry.size.height) * 0.035))
                                            .fontWeight(.bold)
                                    } else {
                                        Text("\(bio.count)")
                                            .foregroundColor(.black)
                                            .font(Font.custom("Avenir-Medium", size: min(geometry.size.width, geometry.size.height) * 0.035))
                                            .fontWeight(.bold)
                                    }
                                }
                                .padding(.trailing, 30)
                            }
                        }
                     
                        
                        Spacer()
                        
                        Button(action: {
                            DispatchQueue.global(qos: .userInteractive).async {
                                    UpdateDB().updateBio(bioText: bio) { response in
                                        if response == "Successful" {
                                            profileBioChanged.toggle()
                                        }
                                    }
                                }
                        }) {
                                Text("Update").font(Font.custom("Avenir-Black", size: min(geometry.size.width, geometry.size.height) * 0.06)).frame(width: geometry.size.width-70, height: 60).background(.black).foregroundColor(.white).cornerRadius(10).font(Font.system(size: 20)).fontWeight(.heavy)
                        }
                        .padding(.bottom)
                        
                        }
                        .frame(width: geometry.size.width-40, height: geometry.size.height-20)
                        }
                        .foregroundColor(.black)
                        .navigationDestination(isPresented: $profileBioChanged) {
                            HomePage(isShownHomePage: false, isChangesMade: false, isShownClassCreated: false, isShownProductCreated: false, isShownLinkCreated: false).navigationBarHidden(true)
                        }
                        .onAppear {
                            bio = bioText
                        }
                    }
    }
}

struct ChangeBio_Previews: PreviewProvider {
    static var previews: some View {
        ChangeBio()
    }
}
