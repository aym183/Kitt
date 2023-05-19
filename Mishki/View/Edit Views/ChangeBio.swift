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
                            Text("Change Bio").font(.system(size: min(geometry.size.width, geometry.size.height) * 0.06)).fontWeight(.semibold).multilineTextAlignment(.leading).padding(.vertical).padding(.leading)
                            
                            Spacer()
                            }
                            
                        
                        TextField("", text: $bio, prompt: Text("Bio").foregroundColor(.gray)).padding().frame(width: geometry.size.width-70, height: 60).foregroundColor(.black).background(Color("TextField")).cornerRadius(10).disableAutocorrection(true).autocapitalization(.none)
                        
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
                                Text("Update").font(.system(size: min(geometry.size.width, geometry.size.height) * 0.06)).frame(width: geometry.size.width-70, height: 60).background(.black).foregroundColor(.white).cornerRadius(10).font(Font.system(size: 20)).fontWeight(.heavy)
                        }
                        .padding(.bottom)
                        
                        }
                        .frame(width: geometry.size.width-40, height: geometry.size.height-20)
                        }
                        .foregroundColor(.black)
                        .navigationDestination(isPresented: $profileBioChanged) {
                            HomePage(isShownHomePage: false, isChangesMade: true, isShownClassCreated: false, isShownProductCreated: false, isShownLinkCreated: false).navigationBarHidden(true)
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