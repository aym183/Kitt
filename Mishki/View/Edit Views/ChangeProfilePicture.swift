//
//  changeProfilePicture.swift
//  Mishki
//
//  Created by Ayman Ali on 18/05/2023.
//

import SwiftUI

struct ChangeProfilePicture: View {
    @State var image: UIImage?
    @State var showImagePicker = false
    @State var profileImageChanged = false
    
    var body: some View {
        GeometryReader { geometry in
                ZStack {
                    Color(.white).ignoresSafeArea()
                    VStack{
                        HStack {
                            Text("Change Profile Picture").font(.system(size: min(geometry.size.width, geometry.size.height) * 0.06)).fontWeight(.semibold).multilineTextAlignment(.leading).padding(.vertical).padding(.leading)
                            
                            Spacer()
                            }
                            
                        
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
                        
                        Spacer()
                        
                        Button(action: {
                            DispatchQueue.global(qos: .userInteractive).async {
                                    if let image = self.image {
                                        CreateDB().uploadProfileImage(image: image) { response in
                                            if response == "Cached" {
                                                profileImageChanged.toggle()
                                            }
                                        }
                                    }
                                }
                        }) {
                                Text("Confirm").font(.system(size: min(geometry.size.width, geometry.size.height) * 0.06)).frame(width: geometry.size.width-70, height: 60).background(.black).foregroundColor(.white).cornerRadius(10).font(Font.system(size: 20)).fontWeight(.heavy)
                        }
                        .padding(.bottom)
                        
                        }
                        .frame(width: geometry.size.width-40, height: geometry.size.height-20)
                        }
                        .foregroundColor(.black)
                        .sheet(isPresented: $showImagePicker) {
                            ImagePicker(image: $image)
                        }
                        .navigationDestination(isPresented: $profileImageChanged) {
                            HomePage(isShownHomePage: false, isChangesMade: true, isShownProductCreated: false, isShownLinkCreated: false).navigationBarHidden(true)
                        }
                    }
                    
            }
    }

struct changeProfilePicture_Previews: PreviewProvider {
    static var previews: some View {
        ChangeProfilePicture()
    }
}
