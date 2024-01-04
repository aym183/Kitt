//
//  UploadImageForm.swift
//  Mishki
//
//  Created by Ayman Ali on 09/05/2023.
//

import SwiftUI

struct UploadProfileImageForm: View {
    @Binding var signUpShown: Bool
    @Binding var username: String
    @Binding var homePageShown: Bool
    @Binding var createAccountSheet: Bool
    @State var showImagePicker = false
    @State var image: UIImage?
    @Binding var createLinkSheet: Bool
    
    var body: some View {
        GeometryReader { geometry in
                ZStack {
                    Color(.white).ignoresSafeArea()
                    VStack(alignment: .leading) {
                        HStack {
                            Text("Pick a profile image").font(Font.custom("Avenir-Black", size: min(geometry.size.width, geometry.size.height) * 0.08))
                            Spacer()
                        }
                        .padding(.bottom, 2)
                        .frame(width: max(0, geometry.size.width-40))
                        
                        Text("Select an image to use as your profile \npicture. It will show up on your page.").font(Font.custom("Avenir-Medium", size: 18)).padding(.leading, 2)
                        
                        HStack {
                            Button(action: { showImagePicker.toggle() }) {
                                ZStack {
                                    if let image = self.image {
                                        Image(uiImage: image)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 80, height: 80)
                                            .cornerRadius(50)
                                    } else {
                                        Circle().fill(.gray).opacity(0.2).frame(width: 80, height: 80)
                                        Image(systemName: "plus").fontWeight(.heavy).font(.system(size: 30))
                                    }
                                }
                            }
                            Text("@\(username)").padding(.leading, 25).font(Font.custom("Avenir-Medium", size: min(geometry.size.width, geometry.size.height) * 0.05)).fontWeight(.bold)
                            Spacer()
                        }
                        .frame(width: max(0, geometry.size.width-60), height: 75)
                        .padding(.vertical, 30).padding(.horizontal, 10)
                        
                        HStack {
                            Button(action: {
                                if let image = self.image {
                                    DispatchQueue.global(qos: .userInteractive).async {
                                        CreateDB().uploadProfileImage(image: image) { response in
                                            if response == "Cached" {
                                                if createAccountSheet == true {
                                                    createAccountSheet.toggle()
                                                }
                                                if createLinkSheet == true {
                                                    createLinkSheet.toggle()
                                                }
                                                signUpShown.toggle()
                                            }
                                        }
                                    }
                                } else {
                                    print("No image uploaded")
                                }
                                
                            }) {
                                HStack {
                                    Text("Confirm").font(Font.custom("Avenir-Black", size: min(geometry.size.width, geometry.size.height) * 0.06))
                                }
                                .frame(width: 200, height: 70)
                                .background(Color.black).foregroundColor(Color.white)
                                .cornerRadius(50)
                            }
                            .padding(.top)
                            
                            Button(action: {
                                if createAccountSheet == true {
                                    createAccountSheet.toggle()
                                }
                                if createLinkSheet == true {
                                    createLinkSheet.toggle()
                                }
                                signUpShown.toggle()
                                }) {
                                Text("I'll do it later").font(Font.custom("Avenir-Black", size: min(geometry.size.width, geometry.size.height) * 0.045)).padding([.top, .leading])
                            }
                        }
                        
                    }
                    .frame(width: max(0, geometry.size.width-40), height: max(0, geometry.size.height-20))
                    .foregroundColor(.black)
                    .padding(.top, 30)
                    .sheet(isPresented: $showImagePicker) {
                        ImagePicker(image: $image)
                    }
                    Spacer()
                }
        }
    }
}
